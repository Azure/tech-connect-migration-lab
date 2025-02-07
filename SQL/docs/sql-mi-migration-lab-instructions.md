# Executive Summary

## Objective

This document has been prepared to list the procedure/steps/instructions that are required to migrate the (AdventureWorks2019) database running on on-premise SQL Server or SQL Server database on any public/private Cloud Service provider VM e.g. Azure VM, AWS EC2 or GCP Compute Engine **to Azure SQL MI**

## Approach

This was devised to list the procedure/steps/instructions to migrate the (AdventureWorks2019) database running on Azure VM **to Azure SQL MI** using MI Link.

Note that this lab assumes a SQL MI instance is already pre-deployed for you.

===


# Execution

**Log In to the machine**
When you launch the lab, you will be prompted to log in to a Windows machine.

 ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img1.png?raw=true)

 The Windows user and password information will be displayed at the bottom of the "Resources" tab. Whenever you see a ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img5.png?raw=true) preceding a text, you can click on it and the text will be typed for you in the text box or application that is active in the UI of the lab screen. 
 
  ![](https://github.com/Azure/tech-connect-migration-lab/blob/main/MySQL/docs/media/skillable_img2.png?raw=true)

### Access validation

#### Sources


===

**Instructions:**

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

    ![PowerShell_Open_File_Restore](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File_Restore.png?raw=true)

5. Click on **Run Script** and wait for the script completion:

    ![PowerShell_Open_File_Restore_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File_Restore_Execute.png?raw=true)

6. Click on **File** Menu from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

7. Copy the file path and click **Open**: +++C:\SQLQueries\InstallWindowsFailoverClusterFeature.ps1+++

    ![PowerShell_Open_File_InstallWindowsFailoverClusterFeature](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_InstallWindowsFailoverClusterFeature.png?raw=true)

8. Click on **Run Script** and wait for the script completion:

    ![PowerShell_InstallWindowsFailoverClusterFeature_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_InstallWindowsFailoverClusterFeature_Execute.png?raw=true)


9. Click on **File** Menu from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

10. Copy the file path and click **Open**: +++C:\SQLQueries\CreateFailoverClusterWithOneNode.ps1+++

    ![PowerShell_Open_File_CreateFailoverClusterWithOneNode](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_CreateFailoverClusterWithOneNode.png?raw=true)

11. Click on **Run Script** and wait for the script completion:

    ![PowerShell_Open_File_CreateFailoverClusterWithOneNode_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_CreateFailoverClusterWithOneNode_Execute.png?raw=true)



12. Click on **File** Menu from PowerShell ISE window and select **Open** file as appears below:

    ![PowerShell_Open_File](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_Open_File.png?raw=true)

13. Copy the file path and click **Open**: +++C:\SQLQueries\OpenFireWallPortonWindows.ps1+++

    ![PowerShell_Open_File_OpenFireWallPortonWindows](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_OpenFireWallPortonWindows.png?raw=true)

14. Click on **Run Script** and wait for the script completion:

    ![PowerShell_Open_File_OpenFireWallPortonWindows_Execute](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_PowerShell_OpenFireWallPortonWindows_Execution.png?raw=true)

15. Click on Search Icon from Taskbar after connecting to the source server and type “**SQL Server Management Studio**” as appears below:

    ![AccessValidation_SSMS](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img1_AccessValidation_SSMS.png?raw=true)


16. Fill in the connection details, Server name as +++TechReadyGImage+++ and Authentication as Windows Authentication. Check Trust server certificate and  Click on the **Connect** button

    ![AccessValidation_SSMS_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img3_AccessValidation_SSMS_ConnectToServer.png?raw=true)


17. Click on the **Databases** after connecting to the source SQL server and then click on the **AdventureWorks2019_xxx** xxx is unique ID for database

    ![AccessValidation_SSMS_ObjectExplorer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img4_AccessValidation_SSMS_ObjectExplorer.png?raw=true)


If you can see the tables as appeared above, then the connectivity to the **source database is successful**.

===

18. Click on Search Icon from Taskbar and type “**SQL Server 2019 Configuration Manager**” as appears below:

    ![AccessValidation_SQLServer Configuration Manager](https://raw.githubusercontent.com/Azure/tech-connect-migration-lab/refs/heads/main/SQL/docs/Images/Img5_AccessValidation_SQL%20Server%20Configuration%20Manager.png)

19. Click on SQL Server 2019 Configuration Manager, which will open a new window.
20. Select the SQL Server Services from the left pane and select the SQL Server (MSSQLSERVER) from the right pane. Right click on SQL Server (MSSQLSERVER) and click on Properties

    ![AccessValidation_SQLServer Configuration Manager_Services](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img6_AccessValidation_SQL%20Server%20Configuration%20Manager_Services.png?raw=true)


22. Select the **Always On Availability Groups** tab from properties windows and click on **Enable Always on Availability Group** checkbox and then select **OK**.

    ![AccessValidation_SQL Server Configuration Manager_SQL Service_AlwaysOnAG](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img7_AccessValidation_SQL%20Server%20Configuration%20Manager_SQL%20Service_AlwaysOnAG.png?raw=true)

23. Select the SQL Server Services from the left pane and select the SQL Server (MSSQLSERVER) from the right pane. Right click on SQL Server (MSSQLSERVER) and click on Properties

    ![AccessValidation_SQLServer Configuration Manager_Services](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img6_AccessValidation_SQL%20Server%20Configuration%20Manager_Services.png?raw=true)

24. Select the **Startup Parameters** tab from properties windows, Specify a startup parameter -T1800 and -T9567 individually and click on Add

    ***If trace flag already present in existing parameter list then close the properties windows and go to step 8***
    ![AccessValidation_SQL Server Configuration Manager_StartupParameter_TraceFlag](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img8_AccessValidation_SQL%20Server%20Configuration%20Manager_StartupParameter_TraceFlag.png?raw=true)

25. Once you add both trace flags, click on **Apply.** Select **OK** to close the Properties window.
26. Select the SQL Server Services from the left pane, select the SQL Server (MSSQLSERVER) from the right pane, right click on SQL Server (MSSQLSERVER) and Select Restart

    ![AccessValidation_SQL Server Configuration Manager_SQL Service_Restart](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img9_AccessValidation_SQL%20Server%20Configuration%20Manager_SQL%20Service_Restart.png?raw=true)

27. Go to SQL Server management studio (SSMS) click on **File** and Select **Open** and then select **File** it will open Open file window, 
    
    ![AccessValidation_SSMS_ValidationByQuery](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img10_AccessValidation_SSMS_OpenQuery.png?raw=true)
    
    open  +++C:\SQLQueries\Query_Validate Configuration.sql+++ script and execute on SQL Server to validate the configuration of your SQL Server instance using SSMS:

    ![AccessValidation_SSMS_ValidationByQuery](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img10_AccessValidation_SSMS_ValidationByQuery.png?raw=true)

28. In SQL Server management studio (SSMS) click on File and Select Open it will open Open file window, open +++C:\SQLQueries\Query_Master Key_Mirroring_EP.sql+++ script. This script will create Master Key and Mirroring endpoint on your SQL server:

    Create database master key in the master database, if one isn't already present. Insert your password in place of &lt;strong_password&gt; in the following script and keep it in a confidential and secure place. Create the certificate from above master key. After this create endpoint using this certificate

    ![AccessValidation_SSMS_ValidationByQuery](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img11_AccessValidation_SSMS_ValidationByQuery.png?raw=true)


===

#### Target

**Instructions:**

29. In SSMS Click on the **Connect** and then select **Database Engine** from drop down which opens Connect to Server window as appears below:

    ![AccessValidation_Target_SSMS_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img13_AccessValidation_Target_SSMS_Connect.png?raw=true)

30. Fill in the connection details as appears below and Click on the **Connect** button

    Server name: +++techready2025.46dfe54ef1ee.database.windows.net+++
    Authentication Type: SQL Authentication
    Login name: +++dbadmin+++ 
    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

    ![AccessValidation_Target_SSMS_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img14_AccessValidation_Target_SSMS_ConnectToServer.png?raw=true)

**Here:** Server is the Destination SQL MI FQDN


===


Click on the **Databases** after connecting to the **Target** SQL MI

![AccessValidation_Target_SSMS_ObjectExplorer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img16_AccessValidation_Target_SSMS_ObjectExplorer.png?raw=true)

If you connect successfully and see Databases folder as appeared above, then the connectivity to the **Target SQL MI is successful**

#### Managed Instance Link Test Connection

===


**Instructions:**

31. In SSMS, on Source Server, Click on the **Databases** then Right click on the **AdventureWorks2019** database**,** Select the **Azure SQL Managed Instance Link** then select **Test Connection** as shown below , it will open Network Checker wizard

    ![AccessValidation_MILink_SSMS_TestConnection](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img20_AccessValidation_MILink_SSMS_TestConnection.png?raw=true)

32. Click Next on Network Checker wizards

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img21_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker.png?raw=true)

33. SQL Server prerequisites page, verify if all the requirements are met.

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Prereq](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img22_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Prereq.png?raw=true)

34. Click Next to Login to Managed Instance and click on Login button

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img23_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI.png?raw=true)

    This will open **Connect to Server** window, provide SQL MI FQDN name, authentication, login details and connection security options as mentioned below and click on connect

    Server name: +++techready2025.46dfe54ef1ee.database.windows.net+++
    Authentication Type: SQL Authentication
    Login name: +++dbadmin+++ 
    Password: +++b"9yVh](w-x@T3Y$)>}:s!+++

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Connect](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img24_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Connect.png?raw=true)

35. You will see **Sign In successful** message. Click next to proceed

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img25_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_LoginToMI_Success.png?raw=true)

36. SQL Managed Instance IP address is automatically detected. **Ensure the SQL server IP address specified below is correct**. Click next

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_NetworkOptions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img26_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_NetworkOptions.png?raw=true)

37. Review Summary and click **Finish**

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img27_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Summary.png?raw=true)

38. Verify the results and make sure all tests are successful and have no issue. Click on close to end the result.

    ![AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img28_AccessValidation_MILink_SSMS_TestConnection_NetworkChecker_Results.png?raw=true)

===


#### MI Link Creation

39. Connect to Source SQL server and right click on **AdventureWorks2019** database and click on **Azure SQL Managed Instance link** and select **New…** as shown below

    ![AccessValidation_MILink_SSMS_New](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img29_AccessValidation_MILink_SSMS_New.png?raw=true)

40. Click Next on New Managed Instance link wizard

    ![AccessValidation_MILink_SSMS_New_Introduction](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img30_AccessValidation_MILink_SSMS_New_Introduction.png?raw=true)

41. Specify the Link Name in next screen and select the **Enable connectivity troubleshooting** option as shown below and click **Next**

    ![AccessValidation_MILink_SSMS_New_Specify_LinkOptions](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img31_AccessValidation_MILink_SSMS_New_Specify_LinkOptions.png?raw=true)

42. Verify Server readiness and make sure **Server is Ready**. Click on **Availability group readiness** and verify readiness. Click **Next**

    ![AccessValidation_MILink_SSMS_New_Requirements_ServerReadiness](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img32_AccessValidation_MILink_SSMS_New_Requirements_ServerReadiness.png?raw=true)

    ![AccessValidation_MILink_SSMS_New_Requirements_AGReadiness](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img33_AccessValidation_MILink_SSMS_New_Requirements_AGReadiness.png?raw=true)

43. Click on checkbox in front of AdventureWorks2019 database and verify the status as Ready as shown below. Click **Next**

    ![AccessValidation_MILink_SSMS_New_Select_Databases](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img34_AccessValidation_MILink_SSMS_New_Select_Databases.png?raw=true)

===

44. Specify secondary replica by clicking on **Add secondary replica** button as shown below

    ![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img35_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica.png?raw=true)

    Click on Sign In, it will open browser for login. Enter your credentials to connect to Azure Portal

    ![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img36_AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn.png?raw=true)

Click on Sign In.. and follow the login step on browser. Once you login on browser you will see Authentication complete message. Close the browser and complete the remaining step on wizard


![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_AuthComplete](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_Portal_Login_MILink_Creation.png?raw=true)

Select the user2 and provide password +++TechConnect@2025+++

![AccessValidation_MILink_SSMS_New_Specify_Secondary_Replica_SignIn_AuthComplete](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_Portal_Login_MILink_Creation_Password.png?raw=true)


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

45. If all validations are successful click Next to proceed

    ![AccessValidation_MILink_SSMS_New_Validation](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img42_AccessValidation_MILink_SSMS_New_Validation.png?raw=true)

46. Verify the choices made in this wizard and click **Finish**

    ![AccessValidation_MILink_SSMS_New_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img43_AccessValidation_MILink_SSMS_New_Summary.png?raw=true)

47. Verify the result and click Close.

    ![AccessValidation_MILink_SSMS_New_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img44_AccessValidation_MILink_SSMS_New_Results.png?raw=true)

48. Verify the MI Link from SSMS as well as shown below. Database will be shown as available and started syncing with source database will show as Synchronized

    ![AccessValidation_MILink_SSMS_New_MI_Link_Verification](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img45_AccessValidation_MILink_SSMS_New_MI_Link_Verification.png?raw=true)

49. Synchronization status from AG dashboard

    ![AccessValidation_MILink_SSMS_New_MI_Link_SyncStatus_AGDashboard](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img46_AccessValidation_MILink_SSMS_New_MI_Link_SyncStatus_AGDashboard.png?raw=true)

===


### Check for SQL specific information

Check and export any SQL specific information like (Db Counts, Table Counts, SQL Logins..etc..)

Run **C:\SQLQueries\DBCount_Query.txt** on SQL Server to capture DB counts and Table counts using SSMS.

===

## Migration/Cutover

### Failover Database

50. Connect to Source SQL server using SQL Server management Studio, expand the Databases folder and Right click on **AdventureWorks2019** database and select **Azure SQL Managed Instance link** and select **Failover…** as shown below

    ![AccessValidation_MILink_SSMS_Failover](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img47_AccessValidation_MILink_SSMS_Failover.png?raw=true)

51. Click Next on Introduction page as shown below

    ![AccessValidation_MILink_SSMS_Failover_Introduction](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img48_AccessValidation_MILink_SSMS_Failover_Introduction.png?raw=true)

52. On Failover type page, Planned manual failover selected by default. Click Next on as shown below

    ![AccessValidation_MILink_SSMS_Failover_Choose_FailoverType](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img49_AccessValidation_MILink_SSMS_Failover_Choose_FailoverType.png?raw=true)

53. Click on Sign In to Login to Azure

    ![AccessValidation_MILink_SSMS_Failover_SignIn](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img50_AccessValidation_MILink_SSMS_Failover_SignIn.png?raw=true)

    Once you sign in it will show you are signed in as your id. Click on Sign in to connect to SQL Managed Instance

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img51_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI.png?raw=true)

54. Select the authentication type as SQL Server Authentication and click on Connect. Once

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_ConnectToServer](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img52_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_ConnectToServer.png?raw=true)

55. Once Sign in successful click Next to proceed

    ![AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_Success](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img53_AccessValidation_MILink_SSMS_Failover_SignIn_SQLMI_Success.png?raw=true)

56. Select the appropriate option for Link removal and AG removal post migration. This is recommended to remove the MI link and Delete AG on Source database post successful migration. Click Next to proceed

    ![AccessValidation_MILink_SSMS_Failover_PostFailover_Operations](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img54_AccessValidation_MILink_SSMS_Failover_PostFailover_Operations.png?raw=true)

57. Verify the choices made and click **Finish**

    ![AccessValidation_MILink_SSMS_Failover_Summary](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img55_AccessValidation_MILink_SSMS_Failover_Summary.png?raw=true)

===

58. Review the result and make sure all tasks are completed successfully as shown below

    ![AccessValidation_MILink_SSMS_Failover_Results](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img56_AccessValidation_MILink_SSMS_Failover_Results.png?raw=true)

59. Verify if the database on SQL MI is online and in Read Write Mode using SQL Server Management Studio. Point the application connection to the database on SQL MI.

===


### Validate DB tables at Source and Destination database

Validate DB tables row count is matching with source DB, Execute the **C:\SQLQueries\To verify row count.SQL** script on source and target AdventureWorks2019_xxx database and both using SSMS and compare the result, row count for all tables on both side should match.

![RowCountValidation_Source_Target](https://github.com/Azure/tech-connect-migration-lab/blob/main/SQL/docs/Images/Img_RowCountValidation_Source_Target.png?raw=true)



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
