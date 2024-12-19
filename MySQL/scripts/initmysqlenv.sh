apt-get -y -qq update
apt-get -y -qq upgrade
apt-get -y -qq install mysql-server
systemctl start mysql
mkdir /home/mysqladmin/data
mkdir /home/mysqladmin/percona
cd /home/mysqladmin/percona
curl -Lv https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.35-30/binary/tarball/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz -o percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz --stderr percona_curl.log
tar -xzvf percona/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz
cd /home/mysqladmin/data
curl -Lv https://downloads.mysql.com/docs/sakila-db.tar.gz -o sakila-db.tar.gz --stderr data_curl.log
tar -xzvf sakila-db.tar.gz
cd /home/mysqladmin/data/sakila-db
sudo mysql -h localhost <sakila-schema.sql
sudo mysql -h localhost <sakila-data.sql
sudo systemctl enable mysql
chown -R mysqladmin:mysqladmin /home/mysqladmin
