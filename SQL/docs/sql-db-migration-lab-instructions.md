# Executive Summary

## Objective

This document has been prepared to list the procedure/steps/instructions that are required to migrate the (AdventureWorks2019_xxx) database running on-premise SQL Server database or SQL Server database on any public/private Cloud Service provider VM e.g. Azure VM, AWS EC2 or GCP Compute Engine **to Azure SQL DB**

## Approach

This was devised to list the procedure/steps/instructions to migrate the (AdventureWorks2019_xxx) database running on Azure VM **to Azure SQL DB** using ADS and DMS.

Note that this lab assumes a SQL DB instance is already pre-deployed for you.

===

# Pre-Requisites

**Log In to the machine**
When you launch the lab, you will be prompted to log in to a Windows machine.

 ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img1.png?raw=true)

 The Windows user and password information will be displayed at the bottom of the "Resources" tab. Whenever you see a ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img5.png?raw=true) preceding a text, you can click on it and the text will be typed for you in the text box or application that is active in the UI of the lab screen. 
 
  ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img2.png?raw=true)


## Pre-migration tasks and validation

### Access validation

#### Source

**Instructions:**

**Connect to your machine using user name/password provided in resource tab. (Go to resource tab sign into Win11-Pro-Base using the user name and password)**

1. Click on Search Icon from Taskbar and type "Remote Desktop Connection" as it appears below

    ![Remote_Desktop_Connection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_Remote_Desktop_Connection.png?raw=true)

    It will open Remote Desktop Connection as shown below, provide the computer name, user name and password to connect

    ![Remote_Desktop_ConnectionOpen](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_Remote_Desktop_Connection_Open.png?raw=true)

    **Please contact lab moderator for the IP address, username and password
    Connect to your machine using user name/password provided by lab moderator.
    Do not use the username password from the resource tab.**

2. Click on Search Icon from Taskbar after connecting to the source server and type “**Windows PowerShell ISE**” as appears below:

![PowerShell_Open](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open.png?raw=true)

3. Click on **File** Menu from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

4. Copy the file path and click **Open**: +++C:\SQLQueries\RestoreDBViaPowershell.ps1+++

   **Run script using the Green Play button and wait for completion**  

    ![PowerShell_Open_File_Restore](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File_Restore.png?raw=true)

5. Click on **File** Menu from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

6. Copy the file path and click **Open**: +++C:\SQLQueries\OpenFireWallPortonWindows.ps1+++

   
    ![PowerShell_Open_File_OpenFireWallPortonWindows](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_OpenFireWallPortonWindows.png?raw=true)

7. Click on **Run Script** and wait for the script completion:

    ![PowerShell_Open_File_OpenFireWallPortonWindows_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_OpenFireWallPortonWindows_Execution.png?raw=true)

8. Click on the Windows/Start button after connecting to the source server and type “**Azure Data Studio**” as appears below:

    ![AV_Source_ADS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img1_AV_Source_ADS.png?raw=true)


9. Click on the **Connections** and then click on the **New Connection** as appears below:

    ![AV_Source_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img2_AV_Source_ADS_NewConnection.png?raw=true)

    Click on Search button on taskbar and type **CMD** and click on Command Prompt 
    
    ![CMD_Open](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img_CMD_Open.png?raw=true)

    Once CMD open type +++ipconfig+++ and hit enter, copy the IP4 Address as shown below

    ![CMD_IPConfig](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img_CMD_IPConfig.png?raw=true)


10. Fill in the connection details as appears below and Click on the **Connect** button

    Server: Source Server IP (copied from previous step)
    
    Authentication Type: SQL Login

    User name: +++dbadmin+++
    
    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++
    ![AV_Source_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img3_AV_Source_ADS_NewConnection_Details.png?raw=true)

    **If connection error appears click on Enable Trust Server certificate** button

 
 
11. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2019_xxx**

    ![AV_Source_ADS_NewConnection_Details_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img4_AV_Source_ADS_NewConnection_Details_DB_Tables.png?raw=true)
    

    If you can see the tables as appeared above, then the connectivity to the **source database is successful**.

===

12. Click on the **Extensions** after connecting to the source SQL server

    ![AV_Source_ADS_Extensions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img5_AV_Source_ADS_Extensions.png?raw=true)
    

13. Type **Azure SQL Migration** in the text box as appears below

    ![AV_Source_ADS_Extensions_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img6_AV_Source_ADS_Extensions_SQLMigration.png?raw=true)
    

14. Azure SQL Migration extension details as appeared below

    ![AV_Source_ADS_Extensions_SQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img7_AV_Source_ADS_Extensions_SQLMigration.png?raw=true)
    


    Note: If it is not already installed, then it appears as below:

    ![AV_Source_ADS_Extensions_SQLMigration_Install](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img8_AV_Source_ADS_Extensions_SQLMigration_Install.png?raw=true)

  

    Click on the **Install** button if it is not already installed

    ![AV_Source_ADS_Extensions_SQLMigration_InstallClick](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img9_AV_Source_ADS_Extensions_SQLMigration_InstallClick.png?raw=true)
    

===

#### Target

**Instructions:**


15. Click on the **Connections** and then click on the **New Connection** as appears below:

    ![AV_Target_ADS_NewConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img11_AV_Target_ADS_NewConnection.png?raw=true)
    

    Fill in the connection details as appears below and Click on the **Connect** button

    Server: +++techready2025sql.database.windows.net+++

    Authentication Type: SQL Login
    
    Login name: +++dbadmin+++

    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

    ![AV_Target_ADS_NewConnection_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img12_AV_Target_ADS_NewConnection_Details.png?raw=true)
    

Click on the **Databases** after connecting to the **Target** SQL server

![AV_Target_ADS_NewConnection_Details_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img14_AV_Target_ADS_NewConnection_Details_DB.png?raw=true)


If you can see any database name under the **system databases** as appeared above, then the connectivity to the **Target database is successful**

===

# Executing Migration

## Migration from SQL Server Database (AdventureWorks2019_xxx)

**Instructions:**

16. Click on Search Icon from Taskbar after connecting to the source server and type “**SQL Server Management Studio**” as appears below:

    ![AccessValidation_SSMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img1_AccessValidation_SSMS.png?raw=true)

17. Fill in the connection details as appears below and Click on the **Connect** button

    Server: +++techready2025sql.database.windows.net+++

    Authentication Type: SQL Server Authentication
    
    Login name: +++dbadmin+++

    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

18. Click on **File** and Select **Open** and then select **File** it will open Open file window 
    
    ![SSMS_File_Open](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img_SSMS_File_Open.png?raw=true)
    
    Open  +++C:\SQLQueries\Create_Database_In_Azure_SQL.sql+++ script and execute it.
    It will create new database as AdventureWorks2019_xxx as shown below, 

    **Enter the database name as it appears in your SSMS window for future use:**

    @lab.TextBox(databaseName)

    ![Img_SSMS_Create_Database](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img_SSMS_Create_Database.png?raw=true)


19. Go to **Azure Data Studio**, right click and choose 'Manage' on the Source database and then Click on the **Azure SQL Migration** as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img25_Migration_ADS_Source_Database_AzureSQLMigration.png?raw=true)


20. Click on New migration as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img26_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration.png?raw=true)
    

21. Select the **AdventureWorks2019_xxx** database to be migrated as appears below and click **next**

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img27_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB.png?raw=true)
    

22. Wait a few minutes for the assessment to complete, then click "**Next**."

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Assessment](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img28_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Assessment.png?raw=true)

===

23. Select the **Target Type** as Azure SQL DB as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img29_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target.png?raw=true)


24. Review the result and Click “Next” as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AssessmentResults](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img30_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AssessmentResults.png?raw=true)
    

25. Click on Link account which will open browser,  login with the provided Azure credentials on browser. Once you login on browser you will see Authentication complete message. Close the browser and complete the remaining step on wizard

    Microsoft Entra tenant, Subscription, location, Resource Group, and Azure SQL Database server will auto populate

    Azure username: +++user2@MngEnvMCAP560650.onmicrosoft.com+++
    
    Azure password: +++TechConnect@2025+++
    
    Fill-in the Azure SQL Target credentials as appears below and Click on “**Connect**”

    Target user name: +++dbadmin+++

    Target password: +++b"9yVh](w-x@T3Y$)>}:s!+++


    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img31_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL.png?raw=true)
    

    **Note**: Connection must be successful as appears below to proceed further with the Migration:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img32_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_Success.png?raw=true)


===

26. Map the source database (AdventureWorks2019_xxx) to Target database (**+++@lab.Variable(databaseName)+++**, created previously in the Target server) and Click “**Next**” as appears below

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_DB](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img33_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DB_Target_AzureSQL_DB.png?raw=true)


===

27. Select the  DMS and refresh to review the DMS to SHIR connection status and click “**Next**”

    Note: DMS connection to the SHIR must be **online** as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Online](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img41_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_Create_SHIR_Online.png?raw=true)


28. Click on “Edit” under Select tables

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img42_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig.png?raw=true)
    

29. Select “Migrate schema to target” and click on “**Update**”

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img43_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Tables.png?raw=true)
    

30. click on “**Run Validation**” as appears below:

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img44_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation.png?raw=true)
    

31. Click on “Done” on click on “**Next**” to go to the last step (7) of the migration

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Details](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img45_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Details.png?raw=true)
    

32. Review the summary and click on “**Start Migration”**

    ![Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img46_Migration_ADS_Source_Database_AzureSQLMigration_NewMigration_DMS_DataSourceConfig_Validation_Summary.png?raw=true)


===

# Monitoring Migration

## Monitor the migration

33. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2019_xxx**

    ![Monitor_Migration_ADS_NewConnection_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img50_Monitor_Migration_ADS_NewConnection_DB_Tables.png?raw=true)


34. Click on the **Azure SQL migration** and click on “Migrations” as appears below:

    ![Monitor_Migration_ADS_SQLMigration_Status](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img51_Monitor_Migration_ADS_SQLMigration_Status.png?raw=true)


    Note: You will see other databases as well in the DMS and target server, those being used by  other lab students. 
    Refresh to check the current migration status. If the migration is successful, it will appear as shown below:

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

35. Click on the **Extensions** as appears below

    ![Validation_ADS_Extension](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img55_Validation_ADS_Extension.png?raw=true)


36. Type **Schema Compare**  in the text box as appears below

    ![Validation_ADS_Extension_SchemaCompare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img56_Validation_ADS_Extension_SchemaCompare.png?raw=true)


Note: Once installed, **Close and reopen Azure Data Studio ** to enable the extension in Azure Data Studio (only required when installing an extension for the first time).

37. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2019_xxx**

    ![Validation_ADS_DB_Tables](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img57_Validation_ADS_DB_Tables.png?raw=true)


38. To open the **Schema Compare** dialog box, right-click the **AdventureWorks2019_xxx** database in Object Explorer and select Schema Compare. **The database you select is set as the Source database** in the comparison.

    ![Validation_ADS_DB_Tables_SchemaCompare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img58_Validation_ADS_DB_Tables_SchemaCompare.png?raw=true)

===

39. Select one of the ellipses (...) to change the Source and Target of your Schema Compare and select **OK**.

    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img59_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget.png?raw=true)


40. Please select **Script database properties** and **Exclude extended properties** in the Options as shown in the image and click OK

    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img60_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script.png?raw=true)


    ![Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script_Options](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img61_Validation_ADS_DB_Tables_SchemaCompare_SourceTarget_Script_Options.png?raw=true)


41. Click on **“Compare”**

    ![Validation_ADS_DB_Tables_SchemaCompare_Compare](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img62_Validation_ADS_DB_Tables_SchemaCompare_Compare.png?raw=true)


    Note: It will report two below differences between source & target. 

    ![Validation_ADS_DB_Tables_SchemaCompare_Compare_Difference](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/sqldbimages/Img63_Validation_ADS_DB_Tables_SchemaCompare_Compare_Difference.png?raw=true)

    Please ignore both. Reason for the differences:
    1)	The table dbo. __migration_status created for the migration purpose
    2)	Constraint name is only not present at the source,

===

# Summary

Migration of AdventureWorks2019_xxx database which runs on Azure VM **to Azure SQL DB** is successful.

Now, you can:

- Perform Source & Target connectivity checks through Azure Data Studio (ADS)
- Create a database through ADS
- Create Azure Database Migration Service (DMS) through ADS
- Migrate a database (AdventureWorks2019_xxx) database from Azure VM to SQL PaaS (i.e. Azure SQL DB)
- Validate migration by comparing databases between source & target
- View comparison results or generate a script to apply changes later at Target or Save the Comparison
