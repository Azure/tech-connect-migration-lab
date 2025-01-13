# MySQL Lab - MySQL on VM and Backup

### Azure MySQL VM ###

The pre-deployed VM comes prepared for the migration.  Installed on the server is MySQL 8.0.37 with the Sakila sample database, Percona XtraBackup, azcopy and the Azure CLI.  Connectivity to the server will be done via the Bastion server that was configured earlier in the lab execises.


### Explore MySQL VM ###

In the next few steps in the lab, you will explore what is pre-installed and make sure that the pre-requisites for the migration are met.  

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connection" tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
1. [] Once loged in type +++sudo mysql -h localhost+++ in the shell to connect to the local instance of MySQL
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_26.png?raw=true)
1. [] Once connected to MySQL, type +++use sakila;+++ to connect to the *sakila* database
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_27.png?raw=true)
