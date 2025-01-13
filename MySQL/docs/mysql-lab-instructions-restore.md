# MySQL Lab - Restore MySQL Backup to Azure Database for MySQL - Flexible Server #

In the next set of exercises, we will use Azure MySQL Import to restore the database backup taken in the previous exercises, into Azure Database for MySQL Flexible Server.  Note that there is no need to stand up a MySQL Flexible Server beforehand, as the migration utility deploys the server as part of the migration.

### Restore the Backup to Azure Database for MySQL Flexible Server ###

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connection" tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Enter +++mysqladmin+++ for the user name and +++Pa$$W0rd!+++ for the password to login to the server (a separate tab will be opened)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_25.png?raw=true)
1. [] In notepad, paste this command for editing +++az mysql flexible-server import create --data-source-type "azure_blob" --data-source "https://\<put storage name here\>.blob.core.windows.net/mysql-backup" --data-source-backup-dir "backup" --data-source-sas-token "\<put container SAS token here\>" --resource-group "tech-connect-mysql-lab" --name "tech-connect-mysql-flex\<put unique suffix here\>" --version 8.0.21 --location eastus2 --admin-user "mysqladmin" --admin-password "ChangeMeLater" --sku-name Standard_D2ads_v5 --tier GeneralPurpose --public-access 0.0.0.0 --storage-size 32 --high-availability Disabled --iops 1000 --storage-auto-grow Enabled"+++
1. [] Replace *\<put storage name here\>* with the blob storage account name
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_38.png?raw=true)
1. [] Replace *\<put container SAS token here\>* with the *SAS token* (not the SAS URI) that was saved earlier on in the lab
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_39.png?raw=true)
1. [] Replace *\<put unique suffix here\>* with a suffix distinct enough to avoid a name colision with an existing MySQL flexible server in Azure
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_40.png?raw=true)
1. [] Validate value replacement
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_41.png?raw=true)
