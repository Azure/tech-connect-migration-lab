# Executive Summary

## Objective

This document has been prepared to list the procedure/steps/instructions that are required to migrate the (AdventureWorks2019) database running on on-premise SQL Server or SQL Server database on any public/private Cloud Service provider VM e.g. Azure VM, AWS EC2 or GCP Compute Engine **to Azure SQL MI**

## Approach

This was devised to list the procedure/steps/instructions to migrate the (AdventureWorks2019) database running on Azure VM **to Azure SQL MI** using MI Link.

## Recommendations

This is to list the complete procedure/steps to migrate the (AdventureWorks2019) database running on Azure VM to Azure SQL MI using MI Link. However, these instructions are to be tested with the actual Skillable lab environment before publishing to a larger audience.

**Note**: The values present in the Screenshots are demo values. Please change the values as Appropriate.

===

## Assumptions

- Source & Target servers are already provisioned
- Migration Assessments/Pre-requisites are already performed (AdventureWorks2019 database is ready to be migrated to Azure SQL MI with NO blockers). Database is in **Full recovery** mode and there is full and log backup already taken.
- Microsoft windows username/Entra ID will be used to perform the database migration activities
- Username & Password will be available to the end users to access the source & target servers
- Connectivity between Source, Target is already set up & tested (Network, NSG, etc.)
- [Supported version of SQL Server](https://learn.microsoft.com/en-us/azure/azure-sql/managed-instance/managed-instance-link-feature-overview?view=azuresql#prerequisites) with the required service update installed. Versions before SQL Server 2016 aren't supported. SQL Server 2017 is not currently supported.
- An Azure SQL Managed Instance deployment, provisioned to any service tier.
- The Managed Instance link is supported on both the General Purpose and Business Critical service tier of Azure SQL Managed Instance. The link feature works with the Enterprise, Developer, and Standard editions of SQL Server.
- For SQL Server, you should have **sysadmin** permissions.
- For Azure SQL Managed Instance, you should be a member of the [SQL Managed Instance Contributor](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#sql-managed-instance-contributor)

===

# Execution

## Pre-migration tasks and validation

### Software requirements

SQL Server Management Studio **(**[**version 20.2**](https://aka.ms/ssmsfullsetup)**)**

SQL Server 2019 with [AdventureWorks2019](https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak) database

Azure SQL MI with **Microsoft Entra authentication**

### Access validation

#### Sources


===

**Instructions:**

After completing this section, you will be able to:

- Check the connectivity to the Source **Server**
- Check the connectivity to the Source **Database**
- Check if Always On availability groups feature enabled on Source SQL Server
- Check if Trace flag T1800 and T9567 are enabled on Source SQL Server
- Validate the configuration using T-SQL on Source SQL Server
- Check the network connectivity between Source SQL server and Destination Managed Instance.

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password

2. Click on the Windows/Start button after connecting to the source server and type “**Windows PowerShell ISE**” as appears below:
    ![PowerShell_Open](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open.png?raw=true)

3. Click on **File** menue from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

4. Copy the file path and click **Open**: +++C:\SQLQueries\RestoreDBViaPowershell.ps1+++

    ![PowerShell_Open_File_Restore](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File_Restore.png?raw=true)

5. Click on **Run Script** and wait for the script completion:

    ![PowerShell_Open_File_Restore_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File_Restore_Execute.png?raw=true)

6. Click on the Windows/Start button after connecting to the source server and type “**SQL Server Management Studio**” as appears below:

    ![AccessValidation_SSMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img1_AccessValidation_SSMS.png?raw=true)


7. Click on the **Connect** and then select **Database Engine** from drop down which open Connect to Server window as appears below:

    ![AccessValidation_SSMS_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img2_AccessValidation_SSMS_Connect.png?raw=true)

8. Fill in the connection details as appears below and Click on the **Connect** button

    ![AccessValidation_SSMS_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img3_AccessValidation_SSMS_ConnectToServer.png?raw=true)

**Here:** Server is the Source server’s FQDN/IP

9. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2019_xxx** xxx is unique ID for database

    ![AccessValidation_SSMS_ObjectExplorer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img4_AccessValidation_SSMS_ObjectExplorer.png?raw=true)


If you can see the tables as appeared above, then the connectivity to the **source database is successful**.

===

1. Click on the Windows/Start button type “**SQL Server 2019 Configuration Manager**” as appears below:

    ![AccessValidation_SQLServer Configuration Manager](https://raw.githubusercontent.com/Azure/tech-connect-migration-lab/refs/heads/main/SQL/docs/Images/Img5_AccessValidation_SQL%20Server%20Configuration%20Manager.png)

2. Click on SQL Server 2019 Configuration Manager, which will open a new window.
3. Select the SQL Server Services from the left pane and select the SQL Server (MSSQLSERVER) from the right pane. Right click on SQL Server (MSSQLSERVER) and click on Properties

    ![AccessValidation_SQLServer Configuration Manager_Services](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img6_AccessValidation_SQL%20Server%20Configuration%20Manager_Services.png?raw=true)


4. Select the **Always On Availability Groups** tab from properties windows and click on **Enable Always on Availability Group** checkbox and then select **OK**.

    ![AccessValidation_SQL Server Configuration Manager_SQL Service_AlwaysOnAG](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img7_AccessValidation_SQL%20Server%20Configuration%20Manager_SQL%20Service_AlwaysOnAG.png?raw=true)

5. Select the **Startup Parameters** tab from properties windows, Specify a startup parameter -T1800 and -T9567 individually and click on Add

    ![AccessValidation_SQL Server Configuration Manager_StartupParameter_TraceFlag](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img8_AccessValidation_SQL%20Server%20Configuration%20Manager_StartupParameter_TraceFlag.png?raw=true)

6. Once you add both trace flags, click on **Apply.** Select **OK** to close the Properties window.
7. Select the SQL Server Services from the left pane, select the SQL Server (MSSQLSERVER) from the right pane, right click on SQL Server (MSSQLSERVER) and Select Restart

    ![AccessValidation_SQL Server Configuration Manager_SQL Service_Restart](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img9_AccessValidation_SQL%20Server%20Configuration%20Manager_SQL%20Service_Restart.png?raw=true)

8. After the restart, In SSMS click on **File** and Select **Open** it will open Open file window, open  +++C:\SQLQueries\Query_Validate Configuration.sql+++ script and execute on SQL Server to validate the configuration of your SQL Server instance using SQL Server management studio (SSMS):

    ![AccessValidation_SSMS_ValidationByQuery](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img10_AccessValidation_SSMS_ValidationByQuery.png?raw=true)

9. Run the **C:\SQLQueries\Query_Master Key_Mirroring_EP.sql** script on SQL Server to create Master Key and Mirroring endpoint on your SQL server using SQL Server management studio (SSMS):

    Create database master key in the master database, if one isn't already present. Insert your password in place of &lt;strong_password&gt; in the following script and keep it in a confidential and secure place. Create the certificate from above master key. After this create endpoint using this certificate

    ![AccessValidation_SSMS_ValidationByQuery](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img11_AccessValidation_SSMS_ValidationByQuery.png?raw=true)


===

#### Target

**Instructions:**

After completing this section, you will be able to: Check the connectivity to the **Target** **Server** from the source server

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**SQL Server Management Studio**” as appears below:

    ![AccessValidation_Target_SSMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img12_AccessValidation_Target_SSMS.png?raw=true)

3. Click on the **Connect** and then select **Database Engine** from drop down which opens Connect to Server window as appears below:

    ![AccessValidation_Target_SSMS_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img13_AccessValidation_Target_SSMS_Connect.png?raw=true)

4. Fill in the connection details as appears below and Click on the **Connect** button

    Server name: +++techready2025.46dfe54ef1ee.database.windows.net+++
    Authentication Type: SQL Authentication
    Login name: +++dbadmin+++ 
    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

    ![AccessValidation_Target_SSMS_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img14_AccessValidation_Target_SSMS_ConnectToServer.png?raw=true)

**Here:** Server is the Destination SQL MI FQDN


The Server Name may be found on the Azure Portal, as appears below

![AccessValidation_Target_FromAzurePortal](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img15_AccessValidation_Target_FromAzurePortal.png?raw=true)

===


Click on the **Databases** after connecting to the **Target** SQL MI

![AccessValidation_Target_SSMS_ObjectExplorer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img16_AccessValidation_Target_SSMS_ObjectExplorer.png?raw=true)

If you connect successfully and see Databases folder as appeared above, then the connectivity to the **Target SQL MI is successful**

#### Managed Instance Link Test Connection

===


**Instructions:**

After completing this section, you will be able to: Check the MI Link Test connection to **Target** **Server** from the source server

1. Connect to the **source** server using Entra ID/administrator using xxxx as the password
2. Click on the Windows/Start button after connecting to the source server and type “**SQL Server Management Studio**” as appears below:

    ![AccessValidation_MILink_SSMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img17_AccessValidation_MILink_SSMS.png?raw=true)

3. Click on the **Connect** and then select **Database Engine** from drop down which open Connect to Server window as appears below:

    ![AccessValidation_MILink_SSMS_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img18_AccessValidation_MILink_SSMS_Connect.png?raw=true)

4. Fill in the connection details as appears below and Click on the **Connect** button

    ![AccessValidation_MILink_SSMS_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img19_AccessValidation_MILink_SSMS_ConnectToServer.png?raw=true)

**Here:** Server is the Source server’s FQDN/IP

===

1. Click on the **Databases** after connecting to the source SQL server and then Right click on the **AdventureWorks2019** database**,** Select the **Azure SQL Managed Instance Link** then select **Test Connection** as shown below , it will open Network Checker wizard

    ![AccessValidation_MILink_SSMS_TestConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img20_AccessValidation_MILink_SSMS_TestConnection.png?raw=true)

2. Click Next on Network Checker wizards

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img21_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker.png?raw=true)

3. SQL Server prerequisites page, verify if all the requirements are met.

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Prereq](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img22_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Prereq.png?raw=true)

4. Click Next to Login to Managed Instance and click on Login button

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img23_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI.png?raw=true)

    This will open **Connect to Server** window, provide SQL MI FQDN name, authentication, login details and connection security options as mentioned below and click on connect

    Server name: +++techready2025.46dfe54ef1ee.database.windows.net+++
    Authentication Type: SQL Authentication
    Login name: +++dbadmin+++ 
    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img24_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Connect.png?raw=true)

5. You will see **Sign In successful** message. Click next to proceed

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img25_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Success.png?raw=true)

6. SQL Managed Instance IP address is automatically detected. **Ensure the SQL server IP address specified below is correct**. Click next

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_NetworkOptions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img26_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_NetworkOptions.png?raw=true)

7. Review Summary and click **Finish**

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img27_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Summary.png?raw=true)

8. Verify the results and make sure all tests are successful and have no issue. Click on close to end the result.

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img28_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Results.png?raw=true)

===


#### MI Link Creation

1. Connect to Source SQL server and right click on **AdventureWorks2019** database and click on **Azure SQL Managed Instance link** and select **New…** as shown below

    ![AccessValidation_MILink_SSMS_New](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img29_AccessValidation_MILink_SSMS_New.png?raw=true)

2. Click Next on New Managed Instance link wizard

    ![AccessValidation_MILink_SSMS_New_Introduction](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img30_AccessValidation_MILink_SSMS_New_Introduction.png?raw=true)

3. Specify the Link Name in next screen and select the **Enable connectivity troubleshooting** option as shown below and click **Next**

    ![AccessValidation_MILink_SSMS_New_Specify_LinkOptions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img31_AccessValidation_MILink_SSMS_New_Specify_LinkOptions.png?raw=true)

4. Verify Server readiness and make sure **Server is Ready**. Click on **Availability group readiness** and verify readiness. Click **Next**

    ![AccessValidation_MILink_SSMS_New_Requirements_ServerReadiness](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img32_AccessValidation_MILink_SSMS_New_Requirements_ServerReadiness.png?raw=true)

    ![AccessValidation_MILink_SSMS_New_Requirements_AGReadiness](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img33_AccessValidation_MILink_SSMS_New_Requirements_AGReadiness.png?raw=true)

5. Click on checkbox in front of AdventureWorks2019 database and verify the status as Ready as shown below. Click **Next**

    ![AccessValidation_MILink_SSMS_New_Select_Databases](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img34_AccessValidation_MILink_SSMS_New_Select_Databases.png?raw=true)

===

6. Specify secondary replica by clicking on **Add secondary replica** button as shown below

    ![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img35_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica.png?raw=true)

    Click on Sign In, it will open browser for login. Enter your credentials to connect to Azure Portal

    ![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img36_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn.png?raw=true)

Click on Sign In.. and follow the login step on browser. Once you login on browser you will see Authentication complete message. Close the browser and complete the remaining step on wizard

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_AuthComplete](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img37_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_AuthComplete.png?raw=true)

Select the subscription, resource group and Managed Instance (Target). Click on **Sign in** to selected SQL Managed Instance as shown below

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_SignIn](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img38_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_SignIn.png?raw=true)

Select the authentication type which you are using to connect to SQL MI, Click on **Connect**

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img39_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_ConnectToServer.png?raw=true)

===

It will show Sign in successful. Click OK to proceed

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img40_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_SQLMI_Success.png?raw=true)

You will see the SQL MI added as Secondary role. Click **Next** to proceed

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img41_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_Success.png?raw=true)

7. If all validations are successful click Next to proceed

    ![AccessValidation_MILink_SSMS_New_Validation](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img42_AccessValidation_MILink_SSMS_New_Validation.png?raw=true)

8. Verify the choices made in this wizard and click **Finish**

    ![AccessValidation_MILink_SSMS_New_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img43_AccessValidation_MILink_SSMS_New_Summary.png?raw=true)

9. Verify the result and click Close.

    ![AccessValidation_MILink_SSMS_New_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img44_AccessValidation_MILink_SSMS_New_Results.png?raw=true)

10. Verify the MI Link from SSMS as well as shown below. Database will be shown as available and started syncing with source database will show as Synchronized

    ![AccessValidation_MILink_SSMS_New_MI_Link_Verification](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img45_AccessValidation_MILink_SSMS_New_MI_Link_Verification.png?raw=true)

11. Synchronization status from AG dashboard

    ![AccessValidation_MILink_SSMS_New_MI_Link_SyncStatus_AGDashboard](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img46_AccessValidation_MILink_SSMS_New_MI_Link_SyncStatus_AGDashboard.png?raw=true)

===


### Check for SQL specific information

Check and export any SQL specific information like (Db Counts, Table Counts, SQL Logins..etc..)

Run **C:\SQLQueries\DBCount_Query.txt** on SQL Server to capture DB counts and Table counts using SSMS.

===

## Migration/Cutover

### Failover Database

1. Connect to Source SQL server using SQL Server management Studio, expand the Databases folder and Right click on **AdventureWorks2019** database and select **Azure SQL Managed Instance link** and select **Failover…** as shown below

    ![AccessValidation_MILink_SSMS_Failover](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img47_AccessValidation_MILink_SSMS_Failover.png?raw=true)

2. Click Next on Introduction page as shown below

    ![AccessValidation_MILink_SSMS_Failover_Introduction](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img48_AccessValidation_MILink_SSMS_Failover_Introduction.png?raw=true)

3. On Failover type page, Planned manual failover selected by default. Click Next on as shown below

    ![AccessValidation_MILink_SSMS_Failover_Choose_FailoverType](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img49_AccessValidation_MILink_SSMS_Failover_Choose_FailoverType.png?raw=true)

4. Click on Sign In to Login to Azure

    ![AccessValidation_MILink_SSMS_Failover_SignIn](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img50_AccessValidation_MILink_SSMS_Failover_SignIn.png?raw=true)

    Once you sign in it will show you are signed in as your id. Click on Sign in to connect to SQL Managed Instance

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img51_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI.png?raw=true)

5. Select the authentication type and click on Connect. Once

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img52_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_ConnectToServer.png?raw=true)

6. Once Sign in successful click Next to proceed

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img53_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_Success.png?raw=true)

7. Select the appropriate option for Link removal and AG removal post migration. This is recommended to remove the MI link and Delete AG on Source database post successful migration. Click Next to proceed

    ![AccessValidation_MILink_SSMS_Failover_PostFailover_Operations](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img54_AccessValidation_MILink_SSMS_Failover_PostFailover_Operations.png?raw=true)

8. Verify the choices made and click **Finish**

    ![AccessValidation_MILink_SSMS_Failover_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img55_AccessValidation_MILink_SSMS_Failover_Summary.png?raw=true)

===

9. Review the result and make sure all tasks are completed successfully as shown below

    ![AccessValidation_MILink_SSMS_Failover_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img56_AccessValidation_MILink_SSMS_Failover_Results.png?raw=true)

10. Verify if the database on SQL MI is online and in Read Write Mode using SQL Server Management Studio. Point the application connection to the database on SQL MI.

===

### Perform migration

Stop applications servers so no new data will be executed on Databases and make sure no users are connected to the database.

### Create logins in target

Create logins on Target SQL DB using the query below:

+++CREATE LOGIN testLogin1 WITH PASSWORD = '&lt;Strong_Password_Goes_Here&gt;';+++

+++CREATE USER \[testLogin1\] FROM LOGIN \[testLogin1\] WITH DEFAULT_SCHEMA=dbo;+++

### Check access/connectivity

Follow the steps mentioned above

===

### Check source DB state

Query to check the status on Source server:-

+++SELECT name, state_desc  FROM sys.databases+++

To change the database state to read only on Source server:-

+++USE \[master\]+++
+++GO+++

+++**ALTER** **DATABASE** \[databasename\] **SET** READ_ONLY **WITH** NO_WAIT+++
+++GO+++

===

### Validate DB tables

Validate DB tables row count is matching with source DB, Execute the **C:\SQLQueries\To verify row count.txt** script on source and Target server both using SSMS.

### Validate logins

validate logins are created properly

Try connecting with the SQL DB user to validate logins.

![Validate Login](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img57_Validate%20Login.png?raw=true)

===

## Rollback

### Change DB state

To change the database state to read only on Source server:-

+++USE \[master\]+++

+++GO+++

+++**ALTER** **DATABASE** \[databasename\] **SET** READ_ONLY **WITH** NO_WAIT+++

GO

===

# Summary

Migration of AdventureWorks2019 database which runs on Azure VM **to Azure SQL MI** using MI LINK is successful.

Now, you can:

- Perform Source & Target connectivity checks through SQL Server Management Studio and MI Link
- Create a database through SQL Server Management Studio
- Create MI Link through SQL Server Management Studio
- Migrate a database (AdventureWorks2019) database from Azure VM to SQL PaaS (i.e. Azure SQL MI)
- Validate migration by comparing databases between source & target
- View comparison results or generate a script to apply changes later at Target or Save the Comparison
