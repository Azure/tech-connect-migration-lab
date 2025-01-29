# MySQL Lab - Azure Setup #

For the MySQL lab, there are Azure resources that have been set up for you.

1. [] In the Azure portal, navigate to the *Resource Groups* (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the *tech-connect-mysql-lab* resource group
1. [] Confirm the following resources and types exist under this resource group (note the storage account suffix will not match that of the image below)
   ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_1.png?raw=true)

### Bastion Server ###

Connectivity and access to the deployed Azure VM will be required for the lab, it will be done through a Bastion server. Creating a Bastion server will take some minutes, therefore kick off the process as a first step and leave it run in the background as you move on to other tasks.

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connect* tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Click on *Deploy Bastion* and let it run in the background
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_3.png?raw=true)
  
### Register the MySQL Resource Provider ###

In order to deploy a Azure MySQL Flexible Server to migrate to, the *Microsoft.DBforMySQL* resource provider must be registered for the subscription.

1. [] In the Azure portal, navigate to the *Subscriptions* (type +++Subscriptions+++ in the Azure search bar and click on the Subscriptions icon in the search results)
1. [] There is only one subscription listed, click on it
1. [] Expand the *Settings* tab and click on *Resource providers*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_5.png?raw=true)
1. [] Search for +++MySQL+++ and select *Microsoft.DBforMySQL*, click on *Register*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_6.png?raw=true)

### Storage Account IAM and SAS Token ###

The migration of VM MySQL workloads involves uploading the backup to an *Azure Storage Account Container* and accessing the container for the upload and restore process via a *SAS token*.  Therefore 2 IAM roles need to be assigned at the storage account level, and a SAS token generated at the container level.

#### IAM ####
1. [] In the Azure portal, navigate to the *Resource Groups* (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the *tech-connect-mysql-lab* resource group
1. [] Click on the storage account listed in the resource group.
1. [] Click on *Access Control (IAM)* tab on the left at the storage account level, click on *Add* to add a role .
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_8.png?raw=true)
1. [] Search for +++Storage Account Key Operator Service Role+++ and select it
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_9.png?raw=true)
1. [] Click on the *Members* tab click on *Select members*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_10.png?raw=true)
1. [] In the search bar, search for your Azure user name +++@lab.CloudPortalCredential(User1).Username+++, select it
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_11.png?raw=true)
1. [] Click on *Review and assign* to assign the role
1. [] **Repeat** steps **4-8** and add the role +++Storage Blob Data Owner+++

#### SAS Token ####
1. [] In the Azure portal, navigate to the *Resource Groups* (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the *tech-connect-mysql-lab* resource group
1. [] Click on the storage account listed in the resource group.
1. [] Expand *Data Storage* from the menu on the left and select *Containers*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_12.png?raw=true)
1. [] One container should be listed called *mysql-backup* click on it
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_13.png?raw=true)
1. [] Expand *Settings* in the menu and click on *Shared access tokens*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_14.png?raw=true)
1. [] From the permissions drop down menu select *Read, Add, Create, Write, Delete, List, Move, Execute*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_15.png?raw=true)
1. [] Specify a *Start* and *Expiry* date for the token one day ahead of the start date of the lab and one day after the end of the lab, select http and https and click on *Generate SAS token and URL*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_16.png?raw=true)   
1. [] Copy and paste the SAS token and URL generated into an editor for use later on
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_17.png?raw=true)
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_18.png?raw=true)  

### Configure MySQL Ports on the VM ###

Port *3306* needs to be opened on the VM for MySQL connectivity.

#### Inbound ####
1. [] In the Azure portal, navigate to the *Resource Groups* (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Networking* tab and click on _Network Settings_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_19.png?raw=true)
1. [] Select *Create port rule* > *Inbound port rule* to add
    - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_20.png?raw=true)
1. [] Select the MySQL port from the *Services* list and click on *Add*
    - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_21.png?raw=true)
   
#### Outbound ####
1. [] In the Azure portal, navigate to the *Resource Groups* (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Networking* tab and click on _Network Settings_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_19.png?raw=true)
1. [] Select *Create port rule* > *Outbound port rule* to add
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_22.png?raw=true)
1. [] Select the MySQL port from the *Services* list and click on *Add*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_23.png?raw=true)

Configuration tasks are done, click on next at the bottom of the window to proceed to the next steps.
