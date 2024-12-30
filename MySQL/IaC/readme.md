# Tech Connect Database Migration Lab - MySQL

## ARM templates to deploy Azure resources for the MySQL Migration Lab

- mysql-resource-grp.json: creates an Azure resource group for all the resources required for the MySQL Lab
    - Can be executed with azure cli: *az deployment sub create --location eastus2 --template-file mysql-resource-grp.json*
- mysql-template.json:  creates the Azure resources required for the lab (Bastion server connection to be created by lab attendees)
    - Can be executed with azure cli: *az deployment group create --resource-group "tech-connect-mysql-lab" --template-file mysql-template.json*
