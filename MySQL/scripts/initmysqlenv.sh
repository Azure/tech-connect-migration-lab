sudo apt-get -y -qq update
sudo apt-get -y -qq upgrade
sudo apt-get -y -qq install mysql-server
sudo systemctl start mysql
mkdir /home/mysqladmin/data
mkdir /home/mysqladmin/percona
curl -Lv https://downloads.percona.com/downloads/Percona-XtraBackup-LATEST/Percona-XtraBackup-8.0.35-30/binary/tarball/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz -o /home/mysqladmin/percona/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz --stderr /home/mysqladmin/percona/percona_curl.log
gzip -d /home/mysqladmin/percona/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar.gz
tar -xf /home/mysqladmin/percona/percona-xtrabackup-8.0.35-30-Linux-x86_64.glibc2.17.tar
cd /home/mysqladmin/data
curl -Lv https://downloads.mysql.com/docs/sakila-db.tar.gz -o /home/mysqladmin/data/sakila-db.tar.gz --stderr /home/mysqladmin/data/data_curl.log
gzip -d /home/mysqladmin/data/sakila-db.tar.gz
tar -xf /home/mysqladmin/data/sakila-db.tar
cd /home/mysqladmin/data/sakila-db
sudo mysql -h localhost </home/mysqladmin/data/sakila-db/sakila-schema.sql
sudo mysql -h localhost </home/mysqladmin/data/sakila-db/sakila-data.sql
sudo systemctl enable mysql
chown -R mysqladmin:mysqladmin /home/mysqladmin
