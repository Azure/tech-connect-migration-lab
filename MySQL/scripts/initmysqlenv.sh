mkdir /home/mysqladmin/data
mkdir /home/mysqladmin/data/backup
mkdir /home/mysqladmin/percona
mkdir /home/mysqladmin/mysql_pkg
mkdir /home/mysqladmin/azcopy
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
cd /home/mysqladmin/mysql_pkg
curl -L https://downloads.mysql.com/archives/get/p/23/file/mysql-server_8.0.37-1ubuntu24.04_amd64.deb-bundle.tar -O
tar -xvf mysql-server_8.0.37-1ubuntu24.04_amd64.deb-bundle.tar
sudo apt-get -y -qq install libaio1
sudo dpkg-preconfigure --frontend=noninteractive --priority=critical mysql-community-server_*.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg -i --log=mysql_install.log --force-all mysql-{common,community-client-plugins,community-client-core,community-client,client,community-server-core,community-server,server}_*.deb
sudo systemctl start mysql
sudo service mysql stop
sudo rm -rf /var/lib/mysql
sudo mkdir /var/lib/mysql    
sudo chown mysql:mysql /var/lib/mysql
sudo chmod 700 /var/lib/mysql
echo "lower_case_table_names = 1" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf
sudo mysqld --defaults-file=/etc/mysql/my.cnf --initialize-insecure=ON --lower_case_table_names=1 --user=mysql --console
sudo service mysql start
sudo systemctl enable mysql
cd /home/mysqladmin/percona
curl -Lv https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.35-30/binary/tarball/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz -o percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz --stderr percona_curl.log
tar -xzvf percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz
mv percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17 percona-xtrabackup
cd /home/mysqladmin/data
curl -Lv https://downloads.mysql.com/docs/sakila-db.tar.gz -o sakila-db.tar.gz --stderr data_curl.log
curl -Lv https://raw.githubusercontent.com/Azure/tech-connect-migration-lab/refs/heads/main/MySQL/scripts/create_role.sql -O --stderr role_curl.log
tar -xzvf sakila-db.tar.gz
sudo mysql -h localhost <create_role.sql
cd /home/mysqladmin/data/sakila-db
sudo mysql -h localhost <sakila-schema.sql
sudo mysql -h localhost <sakila-data.sql
sudo systemctl enable mysql
cd /home/mysqladmin/azcopy
curl -L https://aka.ms/downloadazcopy-v10-linux -o azcopy_linux_amd64_10.27.1.tar.gz
tar -xzvf azcopy_linux_amd64_10.27.1.tar.gz
azcpexe=`ls -d */`
mv /home/mysqladmin/azcopy/$azcpexe /home/mysqladmin/azcopy/bin
sudo chown -R mysqladmin:mysqladmin /home/mysqladmin
