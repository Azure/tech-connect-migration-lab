sudo apt -qq update
sudo apt -qq upgrade
sudo apt -qq install mysql-server
sudo systemctl start mysql
mkdir /home/mysqladmin/data
mkdir /home/mysqladmin/percona
cd percona
curl -L https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.35-30/binary/tarball/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz -o percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz
gzip -d percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz
tar -xf percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar
cd ../data
curl -L https://downloads.mysql.com/docs/sakila-db.tar.gz -o sakila-db.tar.gz
gzip -d sakila-db.tar.gz
tar -xf sakila-db.tar
cd sakila-db
sudo mysql -h localhost <sakila-schema.sql
sudo mysql -h localhost < sakila-data.sql
sudo systemctl enable mysql
