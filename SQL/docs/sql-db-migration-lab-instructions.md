# Executive Summary

## Objective

This document has been prepared to list the procedure/steps/instructions that are required to migrate the (AdventureWorks2016) database running on-premise SQL Server database or SQL Server database on any public/private Cloud Service provider VM e.g. Azure VM, AWS EC2 or GCP Compute Engine **to Azure SQL DB**

## Approach

This was devised to list the procedure/steps/instructions to migrate the (AdventureWorks2016) database running on Azure VM **to Azure SQL DB** using ADS and DMS.

## Recommendations

This is to list the complete procedure/steps to migrate the (AdventureWorks2016) database running on Azure VM to Azure SQL DB using ADS, DMS and Azure Storage. However these instructions are to be tested with the actual Skillable lab environment before publishing to a larger audience.

**Note**: The values present in the Screenshots are demo values. Please change the values as Appropriate.

===

## Assumptions

- Source & Target servers are already provisioned
- Migration Assessments/Pre-requisites are already performed (AdventureWorks2016 database is ready to be migrated to Azure SQL Database with NO blockers)
- Microsoft windows username/Entra ID will be used to perform the database migration activities
- Username & Password will be available to the end users to access the source & target servers
- Connectivity between Source, Target & DMS servers is already setup & tested (Network, NSG, etc.)

# Pre-Requisites

## Pre-migration tasks and validation

### Software requirements

Windows server 2019 with minimum of 4 cores, 8 GB of RAM, 100 GB hard drive space

SQL Server 2022 with [AdventureWorks2016](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2016.bak) database

Azure Data Studio ([version 1.50.0](https://go.microsoft.com/fwlink/?linkid=2298047)) with **Azure SQL Migration & SQL Server Schema Compare** extensions

Azure SQL Database with **Microsoft Entra authentication**. Check Pre-requisite: [Link](https://learn.microsoft.com/en-us/azure/dms/migration-using-azure-data-studio?tabs=azure-sql-db)

Azure Database Migration (DMS) for the source as SQL server and Target as the Azure SQL Database scenario

===

### Access validation

#### Source

**Instructions:**

After completing this section, you will be able to:

- Check the connectivity to the Source **Server**
- Check the connectivity to the Source **Database**
- Check if Azure SQL Migration extension is installed

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**Azure Data Studio**” as appears below:

    ![AV_Source_ADS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img1_AV_Source_ADS.png?raw=true)


3. Click on the **Connections** and then click on the **New Connection** as appears below:

    ![AV_Source_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img2_AV_Source_ADS_NewConnection.png?raw=true)


4. Fill in the connection details as appears below and Click on the **Connect** button

    ![AV_Source_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img3_AV_Source_ADS_NewConnection_Details.png?raw=true)


    **Here:** Server is the Source server’s FQDN/IP

5. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![AV_Source_ADS_NewConnection_Details_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img4_AV_Source_ADS_NewConnection_Details_DB_Tables.png?raw=true)
    

    If you can see the tables as appeared above, then the connectivity to the **source database is successful**.

===

6. Click on the **Extensions** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![AV_Source_ADS_Extensions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img5_AV_Source_ADS_Extensions.png?raw=true)
    

7. Type **Azure SQL Migration** in the text box as appears below

    ![AV_Source_ADS_Extensions_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img6_AV_Source_ADS_Extensions_SQLMigration.png?raw=true)
    

8. Azure SQL Migration extension details as appeared below

    ![AV_Source_ADS_Extensions_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img7_AV_Source_ADS_Extensions_SQLMigration.png?raw=true)
    

    Successfully checked the connectivity to **Source Server, Database** & **SQL Migration extension** installation

    Note: If it is not already installed, then it appears as below:

    ![AV_Source_ADS_Extensions_SQLMigration_Install](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img8_AV_Source_ADS_Extensions_SQLMigration_Install.png?raw=true)

  


    Click on the **Install** button if it is not already installed

    ![AV_Source_ADS_Extensions_SQLMigration_InstallClick](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img9_AV_Source_ADS_Extensions_SQLMigration_InstallClick.png?raw=true)
    

===

#### Target

**Instructions:**

After completing this section, you will be able to: Check the connectivity to the **Target** **Server** from the source server


1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**Azure Data Studio**” as appears below:

    ![AV_Target_ADS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img10_AV_Target_ADS.png?raw=true)
    

    Click on the **Connections** and then click on the **New Connection** as appears below:

    ![AV_Target_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img11_AV_Target_ADS_NewConnection.png?raw=true)
    

    Fill in the connection details as appears below and Click on the **Connect** button

    ![AV_Target_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img12_AV_Target_ADS_NewConnection_Details.png?raw=true)
    

**Here:** **Server** : Target (i.e. Azure SQL DB)’s server Name

**Authentication type**: Select Microsoft Entra ID – Universal with MFA support

**Account:** Account name which has the access to the Azure SQL Database

The Server Name may be found on the Azure Portal, as appears below

![AV_Target_AzurePortal_TargetName](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img13_AV_Target_AzurePortal_TargetName.png?raw=true)


Click on the **Databases** after connecting to the **Target** SQL server

![AV_Target_ADS_NewConnection_Details_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img14_AV_Target_ADS_NewConnection_Details_DB.png?raw=true)


If you can see any database name under the **system databases** as appeared above, then the connectivity to the **Target database is successful**

===

# Executing Migration

## Migration from SQL Server Database (AdventureWorks2016)

**Instructions:**

After completing this lab, you will be able to: Migrate a database (AdventureWorks2016) database from Azure VM to SQL PaaS (i.e. Azure SQL DB)

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**Azure Data Studio**” as appears below:

    ![Migration_ADS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img15_Migration_ADS.png?raw=true)


3. Click on the **Connections** and then click on the **New Connection** as appears below:

    ![Migration_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img16_Migration_ADS_NewConnection.png?raw=true)


4. Fill in the connection details as appears below and Click on the **Connect** button

    ![Migration_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img17_Migration_ADS_NewConnection_Details.png?raw=true)


**Here:** Server is the Source server’s FQDN/IP

5. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![Migration_ADS_NewConnection_Details_DB_tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img18_Migration_ADS_NewConnection_Details_DB_tables.png?raw=true)


If you can see the tables as appeared above, then the connectivity to the **source database is successful**.

===

1. Click on the **Extensions** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![Migration_ADS_Extension](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img19_Migration_ADS_Extension.png?raw=true)


2. Type **Azure SQL Migration** in the text box as appears below

    ![Migration_ADS_Extension_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img20_Migration_ADS_Extension_SQLMigration.png?raw=true)


3. Azure SQL Migration extension details as appeared below

    ![Migration_ADS_Extension_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img21_Migration_ADS_Extension_SQLMigration.png?raw=true)


Successfully checked the connectivity to **Source Server, Database** & **SQL Migration extension** installation

Note: If it is not already installed, then it appears as below:

![Migration_ADS_Extension_SQLMigration_Installation](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img22_Migration_ADS_Extension_SQLMigration_Installation.png?raw=true)


Click on the **Install** button if it is not already installed

![Migration_ADS_Extension_SQLMigration_Installation_Click](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img23_Migration_ADS_Extension_SQLMigration_Installation_Click.png?raw=true)


===

1. Create an empty AdventureWorks2016 database **in the Target server** as appears below

    ![Migration_ADS_Target_CreateEmptyDatabase](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img24_Migration_ADS_Target_CreateEmptyDatabase.png?raw=true)


2. Select the Source database & Double Click on the **Azure SQL Migration** as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img25_Migration_ADS_Source_Database_AzureSQLMigration.png?raw=true)


3. Click on New migration as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img26_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration.png?raw=true)
    

4. Select the **AdventureWorks2016** database to be migrated as appears below and click **next**

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img27_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB.png?raw=true)
    

5. Wait a few minutes for the assessment to complete, then click "**Next**."

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Assessment](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img28_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Assessment.png?raw=true)

===

6. Select the **Target Type** as Azure SQL DB as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img29_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target.png?raw=true)


7. Review the result and Click “Next” as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AssessmentResults](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img30_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AssessmentResults.png?raw=true)
    

8. Fill-in the Azure SQL Target details as appears below and Click on “**Connect**”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img31_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL.png?raw=true)
    

    **Note**: Connection must be successful as appears below to proceed further with the Migration:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img32_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_Success.png?raw=true)


===

1. Map the source database (AdventureWorks2016) to Target database (**AdventureWorks2016** i.e. Created previously in the Target server) and Click “**Next**” as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img33_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_DB.png?raw=true)


2. Create Azure Database Migration Service **(DMS)** by clicking “**Create new**”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img34_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS.png?raw=true)


3. Fill-in the DMS details as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img35_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create.png?raw=true)


    **Note:** Same Azure region for DMS as the target Azure SQL Database for Reduced Latency, No transfer Cost within the same region, Performance reasons.

4. Select “**I want to setup self-hosted integration runtime on my machine (Machine where Azure Data Studio is running)**” as appears below and click on “**Execute script**”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img36_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR.png?raw=true)
    

Note: Click **Yes** if it prompts for the permission to execute:

![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img37_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC.png?raw=true)


[**SHIR**](https://www.microsoft.com/en-us/download/details.aspx?id=39717) **Installation may take up to 20 min** if it is the first time installation.

5. **Press Enter to continue**

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC_PS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img38_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC_PS.png?raw=true)


6. Click on “Done” on the Azure Data Studio for the “Create Azure Database Service”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC_PS_Done](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img39_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_UAC_PS_Done.png?raw=true)


NOTE:

You may choose the “Configure manually” option to **save the download time**

![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Manually](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img40_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Manually.png?raw=true)

===

7. Select the newly created DMS and refresh to review the DMS to SHIR connection status and click “**Next**”

    Note: DMS connection to the SHIR must be **online** as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Online](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img41_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Online.png?raw=true)


8. Click on “Edit” under Select tables

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img42_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig.png?raw=true)
    

9. Select “Migrate schema to target” and click on “**Update**”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img43_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Tables.png?raw=true)
    

10. click on “**Run Validation**” as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img44_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation.png?raw=true)
    

11. Click on “Done” on click on “**Next**” to go to the last step (7) of the migration

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img45_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Details.png?raw=true)
    

12. Review the summary and click on “**Start Migration”**

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img46_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Summary.png?raw=true)


===

# Monitoring Migration

## Monitor the migration

After completing this section, you will be able to: Monitor the migration through Azure Data studio

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**Azure Data Studio**” as appears below:

    ![Monitor_Migration_ADS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img47_Monitor_Migration_ADS.png?raw=true)


3. Click on the **Connections** and then click on the **New Connection** as appears below:

    ![Monitor_Migration_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img48_Monitor_Migration_ADS_NewConnection.png?raw=true)


4. Fill in the connection details as appears below and Click on the **Connect** button

    ![Monitor_Migration_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img49_Monitor_Migration_ADS_NewConnection_Details.png?raw=true)


**Here:** Server is the Source server’s FQDN/IP

===

5. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![Monitor_Migration_ADS_NewConnection_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img50_Monitor_Migration_ADS_NewConnection_DB_Tables.png?raw=true)


6. Click on the **Azure SQL migration** and click on “Migrations” as appears below:

    ![Monitor_Migration_ADS_SQLMigration_Status](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img51_Monitor_Migration_ADS_SQLMigration_Status.png?raw=true)


    Note: Refresh to check the current migration status. If the migration is successful, it will appear as shown below:

    ![Monitor_Migration_ADS_SQLMigration_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img52_Monitor_Migration_ADS_SQLMigration_Success.png?raw=true)


    Click on the source database as shown below to get the complete migration details:

    ![Monitor_Migration_ADS_SQLMigration_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img53_Monitor_Migration_ADS_SQLMigration_Details.png?raw=true)
    

    It will bring up the new window with the detailed information as appears below

    ![Monitor_Migration_ADS_SQLMigration_Details_Info](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img54_Monitor_Migration_ADS_SQLMigration_Details_Info.png?raw=true)


===

# Validating Migration

## Post migration validation

**Instructions:**

After completing this section, you will be able to: Validate the migration by comparing schemas between two databases, View comparison results and Save the Comparison

1. Click on the **Extensions** as appears below

    ![Validation_ADS_Extension](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img55_Validation_ADS_Extension.png?raw=true)


2. Type **Schema Compare**  in the text box as appears below

    ![Validation_ADS_Extension_SchemaCompare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img56_Validation_ADS_Extension_SchemaCompare.png?raw=true)


Note: Once installed, **Reload** to enable the extension in Azure Data Studio (only required when installing an extension for the first time).

3. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2016**

    ![Validation_ADS_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img57_Validation_ADS_DB_Tables.png?raw=true)


4. To open the **Schema Compare** dialog box, right-click the **AdventureWorks2016** database in Object Explorer and select Schema Compare. **The database you select is set as the Source database** in the comparison.

    ![Validation_ADS_DB_Tables_SchemaCompare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img58_Validation_ADS_DB_Tables_SchemaCompare.png?raw=true)

===

5. Select one of the ellipses (...) to change the Source and Target of your Schema Compare and select **OK**.

    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img59_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget.png?raw=true)


6. Please select “Script database properties” in the option

    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img60_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script.png?raw=true)


    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script_Options](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img61_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script_Options.png?raw=true)


7. Click on **“Compare”**

    ![Validation_ADS_DB_Tables_SchemaCompare_Compare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img62_Validation_ADS_DB_Tables_SchemaCompare_Compare.png?raw=true)


    Note: It will report two below differences between source & target. 

    ![Validation_ADS_DB_Tables_SchemaCompare_Compare_Difference](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img63_Validation_ADS_DB_Tables_SchemaCompare_Compare_Difference.png?raw=true)

    Please ignore both. Reason for the differences:
    1)	The table dbo. __migration_status created for the migration purpose
    2)	Constraint name is only not present at the source,

===

# Summary

Migration of AdventureWorks2016 database which runs on Azure VM **to Azure SQL DB** is successful.

Now, you can:

- Perform Source & Target connectivity checks through Azure Data Studio (ADS)
- Create a database through ADS
- Create Azure Database Migration Service (DMS) through ADS
- Migrate a database (AdventureWorks2016) database from Azure VM to SQL PaaS (i.e. Azure SQL DB)
- Validate migration by comparing databases between source & target
- View comparison results or generate a script to apply changes later at Target or Save the Comparison
