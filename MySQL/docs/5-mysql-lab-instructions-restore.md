# MySQL Lab - Restore MySQL Backup to Azure Database for MySQL - Flexible Server #

In the next set of exercises, we will use Azure MySQL Import to restore the database backup taken in the previous exercises, into Azure Database for MySQL Flexible Server.  Note that there is no need to stand up a MySQL Flexible Server beforehand, as the migration utility deploys the server as part of the migration.

### Restore the Backup to Azure Database for MySQL Flexible Server ###

1. [] In notepad, paste this command for editing ```az mysql flexible-server import create --data-source-type "azure_blob" --data-source "https://<put storage name here>.blob.core.windows.net/mysql-backup" --data-source-backup-dir "backup" --data-source-sas-token "<put container SAS token here>" --resource-group "tech-connect-mysql-lab" --name "tech-connect-mysql-flex<put unique suffix here>" --version 8.0.21 --location eastus2 --admin-user "mysqladmin" --admin-password "ChangeMeLater" --sku-name Standard_D2ads_v5 --tier GeneralPurpose --public-access 0.0.0.0 --storage-size 32 --high-availability Disabled --iops 1000 --storage-auto-grow Enabled```
1. [] Replace ```<put storage name here>``` with the blob storage account name
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_38.png?raw=true)
1. [] Replace ```<put container SAS token here>``` with the *SAS token* (not the SAS URI) that was saved earlier on in the lab
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_39.png?raw=true)
1. [] Replace ```<put unique suffix here>``` with a suffix distinct enough to avoid a name collision with an existing MySQL flexible server in Azure
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_40.png?raw=true)
1. [] Validate value replacement
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_41.png?raw=true)
1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
1. [] Once logged in to the VM, at the shell prompt, type +++az login+++ to log in to Azure (follow the login instructions)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_42.png?raw=true)
1. [] Once logged in to azure, at the shell prompt, paste the command you modified above for execution
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_43.png?raw=true)
1. [] Once completed, look at the output and confirm a successful execution
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_44.png?raw=true)
  
### Validate Restored Environment ###

1. [] From the Azure portal, in the *tech-connect-mysql-lab*, ensure that the newly created Azure Database for MySQL -Flexible Server is listed
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_47.png?raw=true)
1. [] From the Azure portal, click on the VM, from the *Overview* tab, take note of and copy the public IP of the VM
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_45.png?raw=true)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_46.png?raw=true)
1. [] From the Azure portal, in the *tech-connect-mysql-lab*, click on the Azure Database for MySQL -Flexible Server
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_47.png?raw=true)
1. [] Expand *Settings* and go to the *Networking* tab   
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_48.png?raw=true)
1. [] Create a new firewall rule +++Tech_Connect_MySQL_VM_IP_Addr+++ with the public IP of the VM you noted above and *Save*  
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_49.png?raw=true)
1. [] Go to the *Connect* tab of the  Azure Database for MySQL -Flexible Server and copy/note the connection string of the server
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_50.png?raw=true)
1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
1. [] Once logged in, from the shell prompt paste the connection string of the server type +++ChangeMeLater+++ as the password for the -p flag (note there is no space)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_51.png?raw=true)
1. [] Once connected to MySQL, type +++use sakila;+++ to connect to the *sakila* database
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_27.png?raw=true)
1. [] Type +++show tables;+++ to list the tables of the *sakila* database
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_28.png?raw=true)
1. [] Type +++select count(\*) from actor;+++ to get the count of rows in the *actor* table
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_29.png?raw=true)
  
This concludes the migration and validation.  You can click on *Back to Lab Menu* to select another lab to try.
