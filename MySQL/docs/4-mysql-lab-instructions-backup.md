# MySQL Lab - MySQL on VM and Backup #

### Azure MySQL VM ###

The pre-deployed VM comes prepared for the migration.  Installed on the server is MySQL 8.0.37 with the Sakila sample database, Percona XtraBackup, azcopy and the Azure CLI.  Connectivity to the server will be done via the Bastion server that was configured earlier in the lab exercises.


### Explore MySQL VM ###

In the next few steps in the lab, you will explore what is pre-installed and make sure that the pre-requisites for the migration are met.  

#### Explore the Sakila Database ####
1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
   **! Alert** You might get a pop-up blocker warning, enable pop-ups originating from the portal and click on *Connect* again!
   ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_52.png?raw=true)
1. [] Once logged in type +++sudo mysql -h localhost+++ in the shell to connect to the local instance of MySQL
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_26.png?raw=true)
1. [] Once connected to MySQL, type +++use sakila;+++ to connect to the *sakila* database
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_27.png?raw=true)
1. [] Type +++show tables;+++ to list the tables of the *sakila* database
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_28.png?raw=true)
1. [] Type +++select count(\*) from actor;+++ to get the count of rows in the *actor* table
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_29.png?raw=true)
  
#### Ensure MySQL Parameter Pre-requisites are met ####

1. [] Type +++show variables like '%lower_case_table_names%';+++ value returned should be *1*
1. [] Type +++show variables like '%innodb_file_per_table%';+++ value returned should be *ON*
1. [] Type +++show variables like '%innodb_page_size%';+++ value returned should be *16384*
1. [] Type +++show variables like '%innodb_data_file_path%';+++ value returned should be *ibdata1* and min size *12M*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_30.png?raw=true)
1. [] Type +++select distinct table_schema,engine from information_schema.tables;+++ value returned should be *INNODB* for the *sakila* schema
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_31.png?raw=true)
1. [] Type +++quit+++ to disconnect from MySQL
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_32.png?raw=true)

### Backup the Full Database Environment Using  Percona XtraBackup ###

In the next set of exercises, you will use Percona XtraBackup to take a physical backup of the MySQL environment and upload it to the Azure blob storage in Azure in anticipation of restoring it to Azure Database for MySQL Flexible Server.

#### Take a Database Backup ####

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
1. [] At the prompt type +++sudo /home/mysqladmin/percona/percona-xtrabackup/bin/xtrabackup --backup --target-dir=/home/mysqladmin/data/backup --user=mysqldba --password='Pa$$w0rd!'+++ to invoke percona xtrabackup backup and take a full backup
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_33.png?raw=true)
1. [] At the prompt type +++sudo /home/mysqladmin/percona/percona-xtrabackup/bin/xtrabackup --prepare --target-dir=/home/mysqladmin/data/backup --user=mysqldba --password='Pa$$w0rd!'+++ to invoke percona xtrabackup prepare and prepare the backup taken for a restore operation
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_34.png?raw=true)

#### Upload Backup to Storage  ####

In the following exercise, we will use azcopy to upload the backup to the blob storage in Azure.

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
1. [] Copy the following command into notepad for editing ```sudo /home/mysqladmin/azcopy/bin/azcopy copy "/home/mysqladmin/data/backup" "<put blob container SAS URI here>" --recursive=true```
1. [] In notepad, replace ```<put blob container SAS URI here>``` with the SAS URI you had generated earlier in the lab and saved.
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_35.png?raw=true)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_36.png?raw=true)
1. [] Copy the modified command and paste it into the command shell for execution.
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_37.png?raw=true)

Database backup and upload to the storage account are completed.  Click on next at the bottom of the window to proceed to the next steps.
