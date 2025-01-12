# MySQL Lab - Azure Setup

For the MySQL lab, there are Azure resources that have been set up for you.

1. [] In the Azure portal, navigate to the Resource Groups (type +++Resource groups+++ in the Azure search bar and click on the Resource groups icon in the search results)
1. [] Click on the *tech-connect-mysql-lab* resource group
1. [] Confirm the following resources and types exist under this resource group (note the storage account suffix will not match that of the image below)
   ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_1.png?raw=true)

### Bastion Server

Connectivity and access to the deployed Azure VM will be required for the lab, it will be done through a Bastion server. Creating a Bastion server will take some minutes, therefore kick off the process as a first step and leave it run in the background as you move on to other tasks.

1. [] Click on the azure vm in the portal *tech-connect-mysql-vm*
1. [] Expand the *Connection" tab and click on _Bastion_
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_4.png?raw=true)
1. [] Click on *Deploy Bastion* and let it run in the background
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_3.png?raw=true)
  
### Register the MySQL Resource Provider

In order to deploy a Azure MySQL Flexible Server to migrate to, the *Microsoft.DBforMySQL* resource provider must be registered for the subscription.

1. [] In the Azure portal, navigate to the *Subscriptions* (type +++Subscriptions+++ in the Azure search bar and click on the Subscriptions icon in the search results)
1. [] There is only one subscription listed, click on it
1. [] Expand the *Settings* tab and click on *Resource providers*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_5.png?raw=true)
1. [] Search for MySQL and select *Microsoft.DBforMySQL*, click on *Register*
   - ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/azure_env_6.png?raw=true)

### Storage Account IAM and SAS Token


