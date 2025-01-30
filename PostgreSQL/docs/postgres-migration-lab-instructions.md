# Migrate PostgreSQL Database on a VM to Azure Database for PostgreSQL Flexible Server
<!-- # @lab.Title  -->

## Introduction  

During this lab, you'll learn how to set up the necessary prerequisites and perform migration of an on-premises PostgreSQL server to Azure Database for PostgreSQL. You'll be performing both an offline and online migration of the Adventureworks sample database, which has already been set up on the source Windows VM. 

## Objectives  

After completing this lab, you'll be able to:  

- Create an Azure Database for PostgreSQL server in Azure. 
- Create a virtual network, gateway, and VPN connection in Azure. 

## Estimated Time  

70 minutes 

## Connection Instructions 

1. [ ] Connect to the virtual machine as +++**@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Username**+++ using +++**@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password**+++ as the password. 

    >[!hint] Select the **+++Type Text+++** icon to enter the associated text into the virtual machine. 

1. [ ] Change the screen resolution if required. 

    >[!hint] You may want to adjust the screen resolution to your own preference. Do this by right-clicking on the desktop and choosing **Screen resolution** and selecting **OK** when finished. 

=== 

## Exercise 1: Create Azure resources 

This exercise shows how to create a private network, private network gateway, and Azure Database for PostgreSQL server within Azure. 

--- 

### Task 1: Create a virtual network in Azure 

The first task is to create an Azure virtual network. This is where the Azure Database for PostgreSQL server will reside, and where the data will be migrated to. 

1. [ ] Connect to the virtual machine using the following credentials: 

    **Username:** +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Username+++   
    **Password:** +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ 

1. [ ] Open Microsoft Edge and go to +++https://portal.azure.com+++. Sign in with the following credentials: 

    **Username:** +++@lab.CloudPortalCredential(User1).Username+++   
    **Password:** +++@lab.CloudPortalCredential(User1).Password+++ 

1. [ ] From the Portal home page, select the **Search resources, services, and docs** bar at the top and search for +++virtual networks+++. 

1. [ ] Select **virtual networks** from the list. 

    !IMAGE[kqg5tagt.jpg](instructions271790/kqg5tagt.jpg) 

1. [ ] At the bottom of the **Virtual Networks** page, select **Create virtual network**. 

    !IMAGE[cxyl3qtv.jpg](instructions271790/cxyl3qtv.jpg) 

1. [ ] On the **Create network** page, configure the **Basics** tab as follows: 

    | Item | Value | 
    |:---------|:---------| 
    | **Subscription**   | (your subscription name) | 
    | **Resource group**   | RG1   | 
    | **Virtual network name**  |   +++Vnet1+++ 
    | **Region**    |   (US) West US 

    >[!alert] Confirm this resource is created in the **West US** region to ensure proper connectivity in later steps.

1. [ ] Select **Next** to continue. 

    !IMAGE[4wr7d9vk.jpg](instructions271790/4wr7d9vk.jpg)

1. [ ] On the **Security** tab, leave all settings as default and select **Next**. 

1. [ ] On the **IP addresses** tab, leave all settings as default and select **Review + create**. 

    >[!knowledge] The setup manager will automatically create an address space and a subnet for you. The default value is 10.0.0.0/16 for the network, and the default subnet is 10.0.0.0/24. These can be changed to whatever you wish, as long as the ranges don’t overlap. The default values will work for the purposes of this lab. 

1. [ ] Once the validation finishes, select **Create** to finish creating the virtual network. 

1. [ ] Once the deployment completes, select **Go to resource**. 

    !IMAGE[zly18int.jpg](instructions271790/zly18int.jpg)

1. [ ] On the **Vnet1** page, select **Settings** then select **Subnets** from the left menu. 

    !IMAGE[awxmtgvs.jpg](instructions271790/awxmtgvs.jpg) 

1. [ ] On the **Vnet1 | Subnets** page, select **+Subnet**. 

1. [ ] Configure the **Add a subnet** blade as follows:  

    | Item | Value | 
    |:---------|:---------| 
    | **Subnet purpose**  | Virtual Network Gateway | 
    | **IPv4 address range**   | 10.0.0.0/16   | 
    | **Starting address** |   +++10.0.1.0+++ 
    | **Size**    |   /27 (32 addresses) 

1. [ ] Select **Add**. 

    !IMAGE[4om5bftb.jpg](instructions271790/4om5bftb.jpg) 

You've successfully completed this task! 

=== 

### Task 2: Create a virtual network gateway in Azure 

In this task, you’ll set up a virtual network gateway in Azure. This gateway will allow the source PostgreSQL server to access the private Azure network over a point-to-site VPN connection. 

1. [ ] From the Azure portal, select the **Search resources, services, and docs** bar at the top and search for +++virtual network gateways+++. 

1. [ ] Select **Virtual network gateways** from the list. 

    !IMAGE[kwa3xaeg.jpg](instructions271790/kwa3xaeg.jpg) 

1. [ ] At the bottom of the **Virtual network gateways** page, select **Create virtual network gateway**. 

    !IMAGE[qpbdihwc.jpg](instructions271790/qpbdihwc.jpg) 

1. [ ] On the **Create virtual network gateway** page, configure the **Basics** tab as follows: 

    | Item | Value | 
    |:---------|:---------| 
    | **Subscription**  | (your subscription name) | 
    | **Name**   | +++Vnet1GW+++   | 
    | **Region** |   West US   | 
    | **Gateway type**    |   VPN   | 
    | **SKU**  | VpnGw2 | 
    | **Generation**   | Generation2   | 
    | **Virtual network** |   Vnet1 | 
    | **Public IP address name**    |   +++Vnet1GWpip+++  | 
    | **Enable active-active mode**  |    Disabled | 

    >[!alert] Confirm this resource is created in the **West US** region to ensure proper connectivity in later steps.

    !IMAGE[4rogvd76.jpg](instructions271790/4rogvd76.jpg)

1. [ ] Select **Review + create** and then select **Create**. 

    >[!note] This process will likely take around 15 minutes. 

1. [ ] Minimize Edge. You’ll return to it in another task. 

You've successfully completed this task! 

=== 

### Task 3: Generate certificates 

In this task, you'll generate a server certificate and client certificate on the source server. These certificates will be needed for the VPN connection to Azure. 

1. [ ] From the desktop, open Windows File Explorer and go to C:\LabFiles. 

1. [ ] Right-click **generate_cert.ps1** and select **Edit**. 

1. [ ] Once the file opens in Powershell ISE, select the top script and then select the **Run Selection** button at the top. 

    !IMAGE[06s4dg8c.jpg](instructions271790/06s4dg8c.jpg) 

1. [ ] Select the bottom script, then select **Run Selection**. 

    >[!note] These two scripts are generating the server and client certificates, respectively. 

1. [ ] In the Windows search bar at the bottom-left, enter +++cert+++ and then select **Manage user certificates**. 

    >[!note] When asked for an administrator password, use +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ 

1. [ ] From the certificate manager, on the left menu, expand **Personal** and then select **Certificates**. 

1. [ ] Right-click the **P2SRootCert** and select **All Tasks**, then select **Export**. 

1. [ ] In the **Certificate Export** wizard, select **Next**.
 
1. [ ] Leave **No, do not export the private key** selected and select **Next**. 

1. [ ] Choose **Base-64 encoded X.509 (.CER)** and select **Next**. 

1. [ ] For the file name, select **Browse** and export the file to C:\LabFiles with the name +++P2SRootCert+++. 

1. [ ] Once the file name is selected, select **Next**, then select **Finish**. 

1. [ ] Once exported, go to C:\LabFiles in Windows File Explorer. 

1. [ ] Right-click the **P2SRootCert** file and select **Open with**, then select **Notepad**. 

1. [ ] Once the file opens in Notepad, select and copy all the lines between **-----BEGIN CERTIFICATE-----** and **-----END CERTIFICATE-----**. 

    !IMAGE[9fgv4aul.jpg](instructions271790/9fgv4aul.jpg) 

You've successfully completed this task! 

=== 

### Task 4: Create Azure Point-to-site connection and install VPN client 

This task will show how to create a Point-to-site connection in Azure. This will allow the installation of a VPN client on the source server. 

1. [ ] From the desktop, switch to Edge with the Microsoft Portal. 

1. [ ] Check the deployment status of the virtual network gateway. When complete, select **Go to resource**. 

    >[!alert] Wait until the gateway is deployed before continuing. This may take several minutes.

1. [ ] On the **Vnet1GW** page, select **Settings** from the left menu, and then select **Point-to-site configuration**. 

1. [ ] Select **Configure now**. 

1. [ ] Configure the **Vnet1GW | Point-to-site configuration** page as follows: 

    | Item | Value | 
    |:---------|:---------| 
    | **Address pool**  | +++172.16.201.0/24+++ | 
    | **Tunnel type**   | IKEv2 and OpenVPN (SSL)   | 
    | **Authentication type** |   Azure certificate | 
    | **Name (Root certificates)**    |   +++RootCertificate+++   | 
    | **Public certificate data (Root certificates)**    |   {Paste the string copied in the previous task}   | 

1. [ ] Select **Save** when finished. 

    !IMAGE[zu5m3pgo.jpg](instructions271790/zu5m3pgo.jpg) 

1. [ ] From the **Vnet1GW | Point-to-site configuration** page, select **Download VPN client** at the top. 

    >[!note] You'll need to wait until the configuration saves, which will take a couple minutes. Once you see **Saved virtual network gateway** in the upper right, you'll be able to download the VPN client file. 

    >!IMAGE[4u6d3skl.jpg](instructions271790/4u6d3skl.jpg) 

1. [ ] Once the download completes, open Windows File Explorer and go to the **Downloads** folder. 

1. [ ] Right-click **Vnet1GW.zip** and select **Extract All**, then select **Extract**. 

1. [ ] From the **Vnet1GW** folder, open the **WindowsAmd64** folder. 

1. [ ] Right-click **VpnClientSetupAmd64** and select **Run as administrator**. 

    !IMAGE[d8kfjswm.jpg](instructions271790/d8kfjswm.jpg) 

    >[!alert] A warning will show stating that the app is unrecognized. Select **More info** and then select **Run anyway**.  

1. [ ] At the User Account Control prompt, enter +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ and select **Yes**. 

1. [ ] Select **Yes** to finish installing the VPN client. 

1. [ ] Once the installation is finished, select the network icon in the notification area and then select the **Vnet1** connection. 

    !IMAGE[ismt7gva.jpg](instructions271790/ismt7gva.jpg) 

1. [ ] From the VPN settings, select **Vnet1** and then select **Connect**. 

    !IMAGE[8wlflp18.jpg](instructions271790/8wlflp18.jpg) 

1. [ ] A separate **Vnet1** connection window will open in the background. Switch to it and select **Connect**. 

    >[!note] A Window may show asking about privilege escalation, select **Continue**. 

    !IMAGE[oigc7yk6.jpg](instructions271790/oigc7yk6.jpg) 

1. [ ] At the User Account Control prompt, enter +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ and select **Yes**. 

1. [ ] Verify that **Vnet1** is connected successfully. The word "Connected" should show under the **Vnet1** connection. 

    !IMAGE[q5bvkdzr.jpg](instructions271790/q5bvkdzr.jpg) 

You've successfully completed this task! 

=== 

### Task 5: Create an Azure Database for PostgreSQL 

In this task, you'll create an Azure Database for PostgreSQL 16 as a migration destination for the PostgreSQL 16 local server. 

1. [ ] From Microsoft Edge, return to the Azure portal. 

1. [ ] Select the **Search resources, services, and docs** bar at the top, search for +++postgres+++, and then select **Azure Database for PostgreSQL - Flexible Servers**. 

    !IMAGE[vzqi07o6.jpg](instructions271790/vzqi07o6.jpg) 

1. [ ] Select **Create Azure Database for PostgreSQL - Flexible Server**. 

1. [ ] On the **New Azure Database for PostgreSQL Flexible server** page, configure the **Basics** tab as follows: 

    | Item | Value | 
    |:---------|:---------| 
    | **Resource group**   | RG1 | 
    | **Server name**   | +++azuredb@lab.LabInstance.Id+++   |  
    | **Region**  |   West US 
    | **PostGreSQL version**    |   16 

    >[!alert] Confirm this resource is created in the **West US** region to ensure proper connectivity in later steps.

1. [ ] Under **Compute + storage**, select **Configure server**. 

1. [ ] Configure the **Compute + storage** page as follows: 

    | Item | Value | 
    |:---------|:---------| 
    | **Compute size**   | Standard_D2ads_v5 2vCores | 
    | **Storage size**   | 32 GiB   |  
    | **Performance Tier**  |   P4 
    | **High availability**    |   Disabled 

    !IMAGE[ggplc8ji.jpg](instructions271790/ggplc8ji.jpg) 

1. [ ] Select **Save** to return to the **Basics** tab. 

1. [ ] On the **Basics** tab, set **High availability** to **Disabled**. 

1. [ ] For **Authentication method**, select **PostgreSQL authentication only**. 

1. [ ] Enter +++postgres+++ for the **Admin username** and +++Passw0rd!+++ for the **Password**. 

    !IMAGE[5ybqy1tx.jpg](instructions271790/5ybqy1tx.jpg) 

1. [ ] Select **Next: Networking >**. 

1. [ ] On the **Networking** tab, configure the following settings: 

    | Item | Value | 
    |:---------|:---------| 
    | **Connectivity method**   | Private access | 
    | **Virtual network**   | Vnet1   |  
    | **Subnet**  |   Vnet1/default 
    | **Private DNS zone**    |   (New) 

    !IMAGE[oabyhrwz.jpg](instructions271790/oabyhrwz.jpg) 

1. [ ] Select **Review + create**, then select **Create**. This process should take 5-7 minutes to complete. 

    >[!knowledge] All the networking was set up first so that we could easily assign it to the new server upon creation. This connectivity method will allow anything on the Vnet1 private network to connect. With the point-to-site VPN connection established, the source server is connected to Vnet1. 

You've successfully completed this task and exercise! 

=== 

## Exercise 2: Complete offline and online migration 

This exercise shows how to complete an offline and an online migration from the on-premises PostgreSQL server to the Azure Database for PostgreSQL server.  

--- 

### Task 1: Perform offline migration 

This task shows how to complete a few final migration options, then perform an offline migration of the Adventureworks database to the Azure Database for PostgreSQL instance in Azure. 

1. [ ] From the Azure portal, select the **Search resources, services, and docs** bar at the top, search for +++private DNS+++, and then select **Private DNS zones**. 

    !IMAGE[126r79z2.jpg](instructions271790/126r79z2.jpg) 

1. [ ] Select the **azuredb@lab.labInstance.Id.private.postgres.database.azure.com** entry. 

1. [ ] Under **DNS Management**, select **Recordsets** and identify the private IP address listed. This should be the only address, and it belongs to the new server. 

    !IMAGE[fa64umoe.jpg](instructions271790/fa64umoe.jpg) 

    >[!note] Your IP may differ from the screenshot. 

1. [ ] Enter the IP address below for future use: 

    @lab.TextBox(privateIP) 

1. [ ] Select **Windows Explorer** from the taskbar, and then go to +++C:\Program files\PostgreSQL\16\data+++. 

1. [ ] Right-click the **pg_hba.conf** file and select **Open with**, then select **Notepad**. 

    >[!note] You'll have to select **More apps** to see **Notepad**. 

1. [ ] In **Notepad**, go to the bottom of the **pg_hba.conf** file and add an entry under **IPv4 local connections** for the following: 

    | Item | Value | 
    |:---------|:---------| 
    | **TYPE**   | +++host+++ | 
    | **DATABASE**   | +++all+++   |  
    | **USER**  |   +++postgres+++ 
    | **ADDRESS**    |   +++@lab.Variable(privateIP)/24+++ 
    | **METHOD**    |   +++scram-sha-256+++ 

    >[!note] The **ADDRESS** listed above is the address from the earlier text box. If it’s blank here, ensure the text box from step 4 is filled out. 

1. [ ] Ensure the file looks like the image below, with the exception of the ADDRESS, if it's different. 

    !IMAGE[lrtr7jn6.jpg](instructions271790/lrtr7jn6.jpg) 

1. [ ] Save and close the file. 

1. [ ] In the Azure portal, return to the home page by selecting **Home** in the upper-left corner. 

1. [ ] Under **Resources**, in the **Recent** list, select **azuredb@lab.LabInstance.Id**. 

1. [ ] On the **azuredb@lab.LabInstance.Id** page, on the left menu, select **Settings** and then select **Server parameters**. 

1. [ ] On the **Server parameters** tab, enter +++azure.extensions+++ in the search filter. 

1. [ ] For the **azure.extensions** parameter, select the **VALUE** dropdown list and select the checkboxes for **UUID-OSSP** and **TABLEFUNC**, then select **Save**. 

    !IMAGE[ga56cijg.jpg](instructions271790/ga56cijg.jpg) 

1. [ ] Once the deployment of the parameters is complete, select the **azuredb@lab.LabInstance.Id | Server parameters** link in the upper-left to return to the server page. 

1. [ ] On the **azuredb@lab.LabInstance.Id** page, on the left menu, select **Migration**. 

1. [ ] On the **Migration** tab, select **+ Create**. 

    !IMAGE[6s94hqsl.jpg](instructions271790/6s94hqsl.jpg) 

1. [ ] On the **Migrate PostgreSQL to Azure Database for PostgreSQL Flexible Server** page, configure the following settings: 

    | Item | Value | 
    |:---------|:---------| 
    | **Migration name**   | +++offlinemigration+++ | 
    | **Source server type**   | On-premise Server   |  
    | **Migration option**  |   Validate and Migrate 
    | **Migration mode**    |   Offline 

    !IMAGE[7nh93svl.jpg](instructions271790/7nh93svl.jpg) 

1. [ ] Select **Next: Select Runtime Server >**. 

1. [ ] On the **Select Runtime Server** tab, leave the default option of **No** selected and select **Next: Connect to source >**. 

1. [ ] From the Windows taskbar, open **Windows PowerShell** and run the +++ipconfig+++ command. 

1. [ ] Select and copy the IP address listed under the **Vnet1** connection, then close PowerShell. 

    >[!note] Select the text and then select **Ctrl+C** to copy. 

    !IMAGE[86lvag86.jpg](instructions271790/86lvag86.jpg) 

1. [ ] Enter the IP address here for future use: 

    @lab.TextBox(VPN) 

1. [ ] In Azure portal, on the **Connect to source** tab, configure the following settings: 

    | Item | Value | 
    |:---------|:---------| 
    | **Server name**   | +++@lab.Variable(VPN)+++ | 
    | **Port**   | +++5432+++   |  
    | **Server admin login name**  |   +++postgres+++ 
    | **Password**    |   +++Passw0rd!+++ 
    | **SSL mode**   | Prefer   |  

    !IMAGE[a3zcj9s8.jpg](instructions271790/a3zcj9s8.jpg) 

    >[!note] Your IP may differ from the screenshot. 

1. [ ] Select **Connect to source**. 

1. [ ] Once the connection test completes, select **Next: Select migration target >**. 

1. [ ] On the **Select migration target** tab, enter +++Passw0rd!+++ in the **Password** field and select **Connect to target**. 

1. [ ] Once the connection test completes, select **Next: Select database(s) for migration >**. 

1. [ ] On the **Select database(s) for migration** tab, select the checkbox for **Adventureworks** and then select **Next: Summary >**. 

1. [ ] Select **Start Validation and Migration**. This process should take 3-4 minutes. 

    >[!knowledge] In an offline migration, all applications that connect to the source instance are stopped. The tradeoff is that it requires less configuration and performs faster. This can be useful in situations where downtime or maintenance is expected. 

1. [ ] Refresh the **azuredb@lab.LabInstance.Id | Migration** page until the **offlinemigration** job is complete. 

1. [ ] Once the migration is complete, select **offlinemigration**. 

    !IMAGE[g6jeja1p.jpg](instructions271790/g6jeja1p.jpg) 

1. [ ] Everything should show as **Succeeded**. At the bottom, select the link to the **Adventureworks** database. 

1. [ ] In the **Validation and migration details for Adventureworks** flyout window, select the **Migration** tab. 

1. [ ] Verify the **Database Status** shows as **Succeeded** and the **Number of tables copied** shows as **68**. 

    !IMAGE[j8kjkklj.jpg](instructions271790/j8kjkklj.jpg) 

You've successfully completed this task! 

=== 

### Task 2: Perform online migration 

This task shows how to complete a few final connection options, then perform an online migration of the Adventureworks database to the Azure Database for PostgreSQL instance in Azure. 

1. [ ] From Windows File Explorer, go to +++C:\Program Files\PostgreSQL\16\data+++ and open the **postgresql.conf** file with **Notepad**. 

1. [ ] In the **postgresql.conf** file, select **Ctrl+F** to find the value +++WAL+++. Select **Find Next** twice to find the correct setting. 

1. [ ] Under the **WRITE-AHEAD-LOG** section, set the **wal_level** value to +++logical+++, and then remove all comments from the line. 

    !IMAGE[yktk443b.jpg](instructions271790/yktk443b.jpg) 

1. [ ] Save and close the file. 

1. [ ] A server restart is required for the changes to take effect. Right-click the Windows icon in the lower left, select **Shut down or sign out**, then select **Restart** to reboot the VM. 

1. [ ] Once the VM has rebooted, sign in again with username +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Username+++ and password +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++. 

1. [ ] Reconnect to the **Vnet1** VPN by selecting the network icon in the notification area and then selecting the **Vnet1** connection. 

    !IMAGE[ismt7gva.jpg](instructions271790/ismt7gva.jpg) 

1. [ ] From the VPN settings, select **Vnet1** and then select **Connect**. 

    !IMAGE[8wlflp18.jpg](instructions271790/8wlflp18.jpg) 

1. [ ] A separate **Vnet1** connection window will open in the background. Switch to it and select **Connect**. 

    >[!note] A Window may show asking about privilege escalation, select **Continue**. 

    !IMAGE[oigc7yk6.jpg](instructions271790/oigc7yk6.jpg) 

1. [ ] At the User Account Control prompt, enter +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ and select **Yes**. 

1. [ ] Verify that **Vnet1** is connected successfully. The word "Connected" should show under the **Vnet1** connection.

    !IMAGE[q5bvkdzr.jpg](instructions271790/q5bvkdzr.jpg) 

1. [ ] If your Microsoft Edge session is not restored, open it and go to +++https://portal.azure.com+++. 

1. [ ] Sign in to the Azure portal with username +++@lab.CloudPortalCredential(User1).Username+++ and password +++@lab.CloudPortalCredential(User1).Password+++.
 
1. [ ] From the Azure portal home page, select **azuredb@lab.LabInstance.Id** from the **Recent** list of resources. 

1. [ ] On the **azuredb@lab.LabInstance.Id** page, select **Migration** from the left menu and then select **+ Create**. 

    !IMAGE[t44jhi2u.jpg](instructions271790/t44jhi2u.jpg) 

1. [ ] On the **Migrate PostgreSQL to Azure Database for PostgreSQL Flexible Server** page, configure the following settings: 

    | Item | Value | 
    |:---------|:---------| 
    | **Migration name**   | +++onlinemigration+++ | 
    | **Source server type**   | On-premise Server   |  
    | **Migration option**  |   Validate and Migrate 
    | **Migration mode**    |   Online 

    >[!note] When switching from **Offline** to **Online** for the **Migration mode**, you might notice an additional prerequisite is added below. The additional prerequisite for the online connection is to set the **WAL_LEVEL** to **logical** in the source server. This is the reason for the extra configuration and server reboot earlier. 

1. [ ] Select **Next: Select Runtime Server >**. 

1. [ ] On the **Select Runtime Server** tab, leave the default option of **No** selected and select **Next: Connect to source >**. 

1. [ ] On the **Connect to source** tab, configure the following settings: 

    | Item | Value | 
    |:---------|:---------| 
    | **Server name**   | +++@lab.Variable(VPN)+++ | 
    | **Port**   | +++5432+++   |  
    | **Server admin login name**  |   +++postgres+++ 
    | **Password**    |   +++Passw0rd!+++ 
    | **SSL mode**   | Prefer   |  

    !IMAGE[a3zcj9s8.jpg](instructions271790/a3zcj9s8.jpg) 

1. [ ] Once the connection test completes, select **Next: Select migration target >**. 

1. [ ] On the **Select migration target** tab, enter +++Passw0rd!+++ in the **Password** field and select **Connect to target**. 

1. [ ] Once the connection test completes, select **Next: Select database(s) for migration >**. 

1. [ ] On the **Select database(s) for migration** tab, select the checkbox for **Adventureworks** and then select **Next: Summary >**. 

    >[!knowledge] After selecting the **Adventureworks** database, there will be an additional checkbox. This is authorizing Azure to overwrite the data from the previous migration with the data from this one. In this case, the data is the same and we can proceed without fear of data loss. However, in a production environment, pay attention to this setting to determine when you’re about to overwrite data. 

1. [ ] Select **Start Validation and Migration**. This process should take 3-4 minutes. 

    >[!knowledge] An online migration has more steps and takes a bit more time, but the source server applications aren't stopped in the process. Data is copied to the target server, then a cutover is performed to finalize the migration with no downtime in between. 

1. [ ] Refresh the **azuredb@lab.LabInstance.Id | Migration** page until the **onlinemigration** job status shows as **Waiting For Use**. 

1. [ ] From the Windows taskbar, select **Windows PowerShell** and run the following command to connect to the newly migrated **Adventureworks** database: 

    ```
    psql -h @lab.Variable(privateIP) -p 5432 -U postgres Adventureworks 
    ``` 

    >[!note] Enter +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ for the password. 

1. [ ] Once connected to the **Adventureworks** database through PowerShell, run the following command: 

    ```
    SELECT name FROM humanresources.department; 
    ``` 

    !IMAGE[k3q6pg5d.jpg](instructions271790/k3q6pg5d.jpg) 

    >[!knowledge] This command should return a list of 16 rows, showing the records in the **department** table. Since the online migration hasn't been completed yet, the data is being pulled from the offline migration performed earlier. With the online migration method, data can be added even after the migration has started, as long as the cutover hasn't been performed yet. Let's add a new row now to test this. 

1. [ ] From the PowerShell connection to **Adventureworks**, run the following command to add a new row to the **department** table. 

    ``` 
    INSERT INTO humanresources.department VALUES (17, 'Logistics', 'Inventory Management', DEFAULT); 
    ``` 

1. [ ] Minimize the PowerShell connection, you'll return to it later. 

1. [ ] Return to the Azure portal and the **azuredb@lab.LabInstance.Id | Migration** page. 

1. [ ] Select **onlinemigration** from the list.

    !IMAGE[on4t9ntj.jpg](instructions271790/on4t9ntj.jpg) 

1. [ ] On the **onlinemigration** page, select **Cutover**, then select **Yes**. This process should take 5-7 minutes to complete. 

    !IMAGE[6euhl3wk.jpg](instructions271790/6euhl3wk.jpg) 

1. [ ] Refresh the **onlinemigration** page until the **Validation status** shows as **Succeeded**. 

1. [ ] At the bottom of the **onlinemigration** page, select the link to the **Adventureworks** database. 

1. [ ] In the **Validation and migration details for Adventureworks** flyout window, select the **Migration** tab. 

1. [ ] Verify the **Database Status** shows as **Succeeded** and the **Number of tables copied** shows as **69**. 

    !IMAGE[xaug5dpz.jpg](instructions271790/xaug5dpz.jpg) 

1. [ ] Return to the **azuredb@lab.LabInstance.Id | Migration** page using the link in the upper left. 

1. [ ] Refresh the **azuredb@lab.LabInstance.Id | Migration** page and verify that the **onlinemigration** shows as **Succeeded**. 

    !IMAGE[9lpbu8gr.jpg](instructions271790/9lpbu8gr.jpg) 

1. [ ] From the Windows taskbar, select **Windows PowerShell** and run the following command: 

    ```
    psql -h @lab.Variable(privateIP) -p 5432 -U postgres Adventureworks 
    ``` 

    >[!note] Enter +++@lab.VirtualMachine(WindowsClientPostgreSQL16.4(LAB301)).Password+++ for the password. 

1. [ ] Once connected to the **Adventureworks** database through PowerShell, run the following command: 

    ```
    SELECT name FROM humanresources.department; 
    ``` 

    !IMAGE[3f9kym3p.jpg](instructions271790/3f9kym3p.jpg) 

    >[!knowledge] We're running this command again to check the row names in the **department** table. At the bottom of the results, notice that the **Logistics** record was migrated successfully. 

You've successfully completed this task and exercise! 

=== 

## Conclusion 

Congratulations! You've completed the **Online and Offline migration of PostgreSQL to Azure Database for PostgreSQL server** lab. Select **End** to close the lab environment and end the lab. 

 