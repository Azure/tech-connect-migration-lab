#!/bin/bash

# Install MongoDB
sudo apt-get install gnupg curl
curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-5.0.gpg \
   --dearmor
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-5.0.gpg ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
sudo apt-get update
sudo apt-get install -y mongodb-org=5.0.29 mongodb-org-database=5.0.29 mongodb-org-server=5.0.29 mongodb-org-shell=5.0.29 mongodb-org-mongos=5.0.29 mongodb-org-tools=5.0.29
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

sudo apt-get install jq -y

# Start mongod service and wait before MongoDB is properly initialized
sudo systemctl enable mongod
sudo systemctl start mongod
sudo systemctl status mongod
sleep 10

# Connect without password, create admin user
MONGO_CONNECTION="mongodb://127.0.0.1:27017/"
MONGO_USERNAME="techconnect"
MONGO_PASSWORD='Pa$$W0rdMongoDB!'
mongouser=$(cat <<EOF
{
    "user": "$MONGO_USERNAME",
    "pwd": "$MONGO_PASSWORD",
    "roles": [{
        "role": "userAdminAnyDatabase",
        "db": "admin"
    },{
        "role": "readWriteAnyDatabase",
        "db": "admin"
    }]
}
EOF
)
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.createUser($mongouser)"

# Run several administrative commands that are unsupported in Azure Cosmos DB for MongoDB vCore
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.adminCommand( { logRotate: 'audit' } )"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.adminCommand( { hostInfo: 1 } )"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.adminCommand( { getLog: 'global' } )"
mongosh $MONGO_CONNECTION --quiet --eval "db.runCommand( { buildInfo: 1 } )"
mongosh $MONGO_CONNECTION --quiet --eval "db.runCommand( { connPoolStats: 1 } )"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.runCommand( { getShardMap: 1 } )"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.runCommand( { top: 1 } )"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.grantRolesToUser('techconnect', [{'role':'clusterAdmin', 'db':'admin'}])"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.revokeRolesFromUser('techconnect', [{'role':'clusterAdmin', 'db':'admin'}])"
mongosh $MONGO_CONNECTION --quiet --eval "db = db.getSiblingDB('admin'); db.grantRolesToUser('techconnect', [{'role':'clusterAdmin', 'db':'admin'}])"

# Shut down and modify config to add password auth, set up replica set, and open firewall (only for demo/testing purposes)
sudo systemctl stop mongod
openssl rand -base64 768 | sudo tee /usr/local/etc/keyfile.txt > /dev/null
sudo chmod 400 /usr/local/etc/keyfile.txt
sudo chown mongodb:mongodb /usr/local/etc/keyfile.txt
sudo sed -i '/#security:/ {
  N
  s/#security:\n/security:\n  authorization: enabled\n  keyFile: \/usr\/local\/etc\/keyfile.txt/
}' /etc/mongod.conf
sudo sed -i '/#replication:/ {
  N
  s/#replication:\n/replication:\n  replSetName: rs0/
}' /etc/mongod.conf
sudo sed -i "$ a setParameter:" /etc/mongod.conf
sudo sed -i "$ a\  enableLocalhostAuthBypass: false" /etc/mongod.conf
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf

# Reboot and wait before MongoDB is properly initialized
sudo systemctl start mongod
sleep 10

# Get public IP of current VM and activate replica set
VM_PUBLIC_IP=$(curl ipinfo.io/ip)
mongosh $MONGO_CONNECTION -u $MONGO_USERNAME -p $MONGO_PASSWORD --quiet --eval "db = db.getSiblingDB('admin'); rs.initiate({_id: \"rs0\", version: 1, members: [{ _id: 0, host : \"$VM_PUBLIC_IP:27017\" }]})"
MONGO_CONNECTION+="?replicaSet=rs0"

# Create load data script
sudo tee /usr/local/etc/load_data.sh >> /dev/null <<EOF
#!/bin/bash

# Connection details
MONGO_CONNECTION="$MONGO_CONNECTION"
MONGO_USERNAME="$MONGO_USERNAME"
MONGO_PASSWORD='$MONGO_PASSWORD'

EOF
sudo tee -a /usr/local/etc/load_data.sh >> /dev/null <<'EOF'
cd $HOME

curl -o customers.json https://raw.githubusercontent.com/AzureCosmosDB/CosmicWorks/refs/heads/master/data/cosmic-works-v3/customer
curl -o products.json https://raw.githubusercontent.com/AzureCosmosDB/CosmicWorks/refs/heads/master/data/cosmic-works-v3/product
curl -o sales.json https://raw.githubusercontent.com/AzureCosmosDB/CosmicWorks/refs/heads/master/data/cosmic-works-v3/salesOrder

sed -i 's/"id":/"_id":/g' customers.json
sed -i 's/"id":/"_id":/g' products.json
sed -i 's/"id":/"_id":/g' sales.json

db=$(echo $USER | cut -d '@' -f1)

mongoimport $MONGO_CONNECTION -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase admin --jsonArray --db "prod-db-$db" --collection customers --file customers.json
mongoimport $MONGO_CONNECTION -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase admin --jsonArray --db "prod-db-$db" --collection products --file products.json
mongoimport $MONGO_CONNECTION -u $MONGO_USERNAME -p $MONGO_PASSWORD --authenticationDatabase admin --jsonArray --db "prod-db-$db" --collection sales --file sales.json

# Also update user under which continuous ingestion service will run 
sudo sed -i "s/unknownlabuser/$USER/" /etc/systemd/system/new_sales_generator.service
sudo systemctl daemon-reload
EOF
sudo chmod a+x /usr/local/etc/load_data.sh

# Create mock app script
sudo tee /usr/local/bin/new_sales_generator.sh >> /dev/null <<EOF
#!/bin/bash

# Connection details
MONGO_CONNECTION="$MONGO_CONNECTION"
MONGO_USERNAME="$MONGO_USERNAME"
MONGO_PASSWORD='$MONGO_PASSWORD'

EOF
sudo tee -a /usr/local/bin/new_sales_generator.sh >> /dev/null <<'EOF'
# Loop to insert a record every 5 seconds
while true; do

    # Define sample JSON
    json='
    {
        "_id": "001676F7-0B70-400B-9B7D-24BA37B97F70",
        "customerId": "D51E01B8-1411-4A59-8A7F-19E7BCCA5CAF",
        "orderDate": "2013-06-02T00:00:00",
        "shipDate": "2013-06-09T00:00:00",
        "details": [{
            "sku": "HL-U509-R",
            "name": "Sport-100 Helmet, Red",
            "price": 34.99,
            "quantity": 1
        },{
            "sku": "BK-T79Y-50",
            "name": "Touring-1000 Yellow, 50",
            "price": 2384.07,
            "quantity": 1
        }]
    }'

    # Generate a new random GUID with all caps
    new_id=$(uuidgen | tr 'a-z' 'A-Z')

    # Get the current date and time
    current_date=$(TZ="America/Los_Angeles" date +"%Y-%m-%dT%H:%M:%S")

    # Update sample JSON
    json=$(echo "$json" | jq --arg new_id "$new_id" --arg current_date "$current_date" '
    .["_id"] = $new_id |
    .orderDate = $current_date |
    .shipDate = null
    ')

    db=$(echo $USER | cut -d '@' -f1)

    # Insert updated JSON to sales collection
    mongosh $MONGO_CONNECTION -u $MONGO_USERNAME -p $MONGO_PASSWORD --quiet --eval "db = db.getSiblingDB('prod-db-$db'); db.sales.insertOne($json)" 

    # Wait before next iteration
    sleep 5
done
EOF
sudo chmod a+x /usr/local/bin/new_sales_generator.sh

# Create a simple deamon
sudo tee /etc/systemd/system/new_sales_generator.service >> /dev/null <<EOF
[Service]
ExecStart=/usr/local/bin/new_sales_generator.sh
Restart=always
User=unknownlabuser

[Install]
WantedBy=multi-user.target
EOF
