# MongoDB Lab - Connect

## Locate pre-created Azure resources

As part of this lab, both source VM hosting MongoDB and target Azure Cosmos DB for MongoDB vCore were pre-created for you. This was done to save time as the Azure Cosmos DB for MongoDB vCore service typically takes around 15 minutes to create. Both these resources were deployed with standard configuration except for networking, which is set to public endpoint. For production set up, you would want such resources inaccessible from public internet.

1. Connect to the virtual machine "Win11-Pro-Base" as +++**@lab.VirtualMachine(Win11-Pro-Base).Username**+++ using +++**@lab.VirtualMachine(Win11-Pro-Base).Password**+++ as the password. 

    >[!hint] Select the **+++Type Text+++** icon to enter the associated text into the virtual machine. 

2. (Optional) Change the screen resolution if required. 

    >[!hint] You may want to adjust the screen resolution to your own preference. Do this by right-clicking on the desktop and choosing **Screen resolution** and selecting **OK** when finished. 

3. The first task is to locate and connect to the source MongoDB. Open Microsoft Edge browser and navigate to +++https://portal.azure.com+++. Sign in with the following credentials: 

    **Username:** +++@lab.CloudPortalCredential(User1).Username+++   
    **Password:** +++@lab.CloudPortalCredential(User1).Password+++
   
   Select Yes when prompted to stay signed in.

4. From the Portal home page, select the **Search resources, services, and docs** bar at the top and search for +++resource groups+++. 

5. Select **Resource groups** from the list.
//INCLUDE IMAGE

6. Select **techconnect-mongodb-lab** from the list.
//INCLUDE IMAGE

7. Select **techconnect-vm-mongodb** from the list. This is the VM hosting a replica of MongoDB database that was pre-created for you. This VM will serve as the migration source.
//INCLUDE IMAGE

8. On the Virtual machine overview page, locate the Public IP address and enter it below for future use:

    @lab.TextBox(MongoDBVMPublicIP)

    >[!note] Your IP address will differ from the screenshot. 
//INCLUDE IMAGE

9. Minimize Microsoft Edge browser and launch **MongoDB Compass**, which is pre-installed for you on the Desktop. MongoDB Compass is popular tool for querying and administering MongoDB databases. Note: This tool is neither maintained nor developed by Microsoft Corp.
//INCLUDE IMAGE

10. Click on **+ Add new connection**
//INCLUDE IMAGE

11. On the next screen, enter the following:

    **URI:** +++mongodb://techconnect:Pa$$W0rdMongoDB!@@lab.Variable(MongoDBVMPublicIP):27017/?authMechanism=SCRAM-SHA-256&replicaSet=rs0+++
    **Name:** +++MongoDB VM+++

    >[!note] Your IP address will differ from the screenshot. If no IP address is visible, please return to step 8 and fill in the box.

    Next, click **Save & Connect** in the bottom right-hand corner.   
//INCLUDE IMAGE

12. You should see a success message and your MongoDB VM should now be visible in the menu on the left-hand side. Great!

    Oh, but only three databases are visible - admin, config, and local - and these are all system databases. There is no user-created database. Let's fix that and upload some data!
//INCLUDE IMAGE

13. Return to Microsoft Edge browser. The VM overview page should still be open. Click on **Connect** then select **Connect** from the drop down.
//INCLUDE IMAGE

14. On the next page, select **SSH using Azure CLI** .
//INCLUDE IMAGE

    A pop up window should open on the right-hand side of your screen. Azure Portal will now validate that all prerequisites to connect using Azure CLI are met. This will take about 15 seconds. //INCLUDE IMAGE

    Once validation completes, acknowledge the warning about just-in-time policy and click **Configure + connect**

    A new pop up window with console environment will appear at the bottom of your screen. Please wait while connection completes. Do not yet type anything into the console. It might take 15 seconds to connect. As this window is typically very small, let's click to maximize it to give ourselves more real estate.
//INCLUDE

    Once connected, you will be asked whther you want to continue connecting. Type +++yes+++ into the console and press enter.
