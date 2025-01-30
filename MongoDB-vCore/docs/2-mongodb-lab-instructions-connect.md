# MongoDB Lab - Connect

## Locate pre-created Azure resources

As part of this lab, both the source VM hosting MongoDB and the target Azure Cosmos DB for MongoDB vCore were pre-created for you. This was done to save time as the Azure Cosmos DB for MongoDB vCore service typically takes around 15 minutes to create. Both these resources were deployed with standard configuration except for networking, which is set to public endpoint. For production set up, you would want such resources inaccessible from public internet.

1. Connect to the virtual machine **"Win11-Pro-Base"** as: 

    **Username:** +++@lab.VirtualMachine(Win11-Pro-Base).Username+++   
    **Password:** +++@lab.VirtualMachine(Win11-Pro-Base).Password+++ 

    >[!hint] Select the **+++Type Text+++** icon to enter the associated text into the virtual machine. 

3. (Optional) Change the screen resolution if required. 

    >[!hint] You may want to adjust the screen resolution to your own preference. Do this by right-clicking on the desktop and choosing **Screen resolution** and selecting **OK** when finished. 

4. The first task is to locate and connect to the source MongoDB. Open the Microsoft Edge browser and navigate to +++https://portal.azure.com+++. Sign in with the following credentials: 

    **Username:** +++@lab.CloudPortalCredential(User1).Username+++   
    **Password:** +++@lab.CloudPortalCredential(User1).Password+++
   
   Select Yes when prompted to stay signed in.

5. From the Portal home page, select the **Search resources, services, and docs** bar at the top and search for +++resource groups+++. 

6. Select **Resource groups** from the list.
![resource groups](./media/resource%20groups.png?raw=true)

7. Select **techconnect-mongodb-lab** from the list.
![resource groups2](./media/resource%20groups%202.png?raw=true)

8. Select **techconnect-vm-mongodb** from the list. This is the VM hosting a replica of the MongoDB database that was pre-created for you. This VM will serve as the migration source.
![mongodb vm](./media/mongo%20vm.png?raw=true)

9. On the Virtual machine overview page, locate the Public IP address and enter it below for future use:

    @lab.TextBox(MongoDBVMPublicIP)

    >[!note] Your IP address will differ from the screenshot. 
![mongodb vm2](./media/mongo%20vm2.png?raw=true)

10. Minimize Microsoft Edge browser and launch **MongoDB Compass**, which is pre-installed for you on the Desktop. MongoDB Compass is a popular tool for querying and administering MongoDB databases. Note: This tool is neither maintained nor developed by Microsoft Corp.
![mongodb compass](./media/mongo%20compass.png?raw=true)

11. Click on **+ Add new connection**
![mongodb compass2](./media/mongo%20compass2.png?raw=true)

12. On the next screen, enter the following:

    **URI:** +++mongodb://@lab.Variable(MongoDBUsername):@lab.Variable(MongoDBPassword)@@lab.Variable(MongoDBVMPublicIP):27017/?authMechanism=SCRAM-SHA-256&replicaSet=rs0+++
    **Name:** +++MongoDB VM+++

    >[!note] Your IP address will differ from the screenshot. If no IP address is visible, please return to step 8 and fill in the box.

    Next, click **Save & Connect** in the bottom right-hand corner.   
    ![mongodb compass3](./media/mongo%20compass3.png?raw=true)

13. You should see a success message and your MongoDB VM should now be visible in the menu on the left-hand side. Great!

    Oh, but only three databases are visible - admin, config, and local - and these are all system databases. There is no user-created database. Let's fix that and upload some data!
![mongodb compass4](./media/mongo%20compass4.png?raw=true)

14. Return to Microsoft Edge browser. The VM overview page should still be open. Click on **Connect** then select **Connect** from the drop down.
![mongodb vm3](./media/mongo%20vm3.png?raw=true)

15. On the next page, select **SSH using Azure CLI** .
![mongodb vm4](./media/mongo%20vm4.png?raw=true)

    A pop up window should open on the right-hand side of your screen. Azure Portal will now validate that all prerequisites to connect using Azure CLI are met. This will take about 15 seconds.
    ![mongodb vm5](./media/mongo%20vm5.png?raw=true)

    Once validation completes, acknowledge the warning about just-in-time policy and click **Configure + connect**
   ![mongodb vm6](./media/mongo%20vm6.png?raw=true)

    A new pop-up window with console environment will appear at the bottom of your screen. As this window is typically very small, let's click to maximize it to give ourselves more real estate.

    You will first be prompted to select console type. Select **Bash**.
    ![console0a](./media/console0a.png?raw=true)

    On the next screen select **No storage account required** and select only available Subscription in the drop down. Click **Apply**. 
    ![console0b](./media/console0b.png?raw=true)

    A connection to your VM will now be initiated. Please wait while the connection initialization completes; it might take 10-15 seconds. You will then be prompted to confirm: **"Are you sure you want to continue connecting (yes/no/fingerprint)?"** Type **+++yes+++** into the console and press enter.

    You are now connected to the VM hosting MongoDB. You should see the following:
    ![console1](./media/console1.png?raw=true)

17. Let's now create a new database and load some data. Because, in a regular migration, you would be dealing with a system that is used for production and already has data, we will fast-track this step and run a script that will populate the database for you. The script is already pre-loaded on the machine for you and will use sales data from the [CosmicWorks](https://github.com/AzureCosmosDB/CosmicWorks) dataset. Type +++/usr/local/etc/load_data.sh+++ into the console and press enter. This will execute the script.

    In about 10 seconds, the script will complete the data load. You should see that tens of thousands of documents have just been loaded successfully.
    ![console2](./media/console2.png?raw=true)

    Great! Now we have a database with some data in it. But, a in real-world scenario, we would also have an app connected to the database and generating some traffic. Let's fix that in the next step.

18. Likewise, the app is already deployed to our machine. To mock an app we use a simple Linux daemon that continuously writes new sales records. Let's start the daemon. First type +++sudo systemctl enable new_sales_generator.service+++ and press enter. Next, type +++sudo systemctl start new_sales_generator.service+++ and press enter again.

19. Let's now return to MongoDB Compass and refresh the list of available databases. Click on **...** next to MongoDB VM and select **Refresh databases** from the menu that appears.
![mongodb compass5](./media/mongo%20compass5.png?raw=true)

    You should now see a database named **prod-db-user1-@lab.LabInstance.Id**. Click on the arrow next to database name to see the collections.
    ![mongodb compass6](./media/mongo%20compass6.png?raw=true)

    Three collections have been loaded: customers, products, and sales. Click on **sales** collection. You will now see the JSON documents stored in the collection. Take note of the number of documents shown on the right-hand side.

    Now, **press the refresh button** next to the document count. You should see the document count go up - this is because our application (launched in step 16) is running and writing new sales records.

    ![mongodb compass7](./media/mongo%20compass7.png?raw=true)
    ![mongodb compass8](./media/mongo%20compass8.png?raw=true)

    >[!note] Your document count will differ from the screenshot. The idea here is to observe that document count increases over time. Also, you may need to press refresh a few times to see the count go up. New sales record is written only every 5 seconds.

    This concludes the preparation section. Let's now go and migrate this MongoDB VM to Azure Cosmos DB for MongoDB vCore!
