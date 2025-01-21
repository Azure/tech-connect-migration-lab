# MongoDB Lab - Offline migration

## Perform offline migration

In this step, we will attempt the more traditional migration approach - offline - that is one where application downtime is necessary. Such approach is suitable for migration of smaller volumes of data and/or for non-critical systems where downtime is acceptable (e.g., an internal-facing app is taken offline for a few hours on a Saturday night).

1. Minimize any open application windows and launch **Azure Data Studio**, which is pre-installed for you on the Desktop. As mentioned earlier, Azure Data Studio is Microsoft's preferred tool for executing MongoDB migrations.
   ![ads1](./media/ads1.png?raw=true)

2. Once Data Studio launches, **click on the person icon** in the bottom left-hand corner.
   ![ads2](./media/ads2.png?raw=true)

   A pop up window will appear on the right-hand side of your screen. Click on **Add an account**.
   ![ads2x](./media/ads2x.png?raw=true)

   Doing so will open the Edge browser and prompt you to log in. Select **Use another account** and enter the following:

   ![ads3](./media/ads3.png?raw=true)

    **Username:** +++User1-47490180@LODSPRODMCA.onmicrosoft.com+++
    **Password:** +++XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX+++

    >[!alert] Do not select the already signed in account. If you by accident select the existing account, return to Data Studio, remove the account and repeat this step.

    >[!note] Here, were are selecting different user account as the target database, Azure Cosmos DB MongoDB vCore, is provisioned in a different Azure environment; one that your lab user does not have permissions over.

3. Next, click on **extensions** in the left-hand menu and search for ++cosmos db++. Locate Azure Cosmos DB Migration for MongoDB extension and click on **Install**.
   //INCLUDE IMAGE

4. Let us now establish connection to our source VM and begin the migration steps. Select **connections** and click **New Connection**.

    A pop window will appear on the right-hand side of your screen. Select connection type **Azure Cosmos DB for MongoDB**.
    //INCLUDE IMAGE

   >[!note] The same connection type can be used to connect to any MongoDB wire-protocol compatible installation. In this case, we are not connecting to Azure Cosmos DB for MongoDB but to native MongoDB on a VM.

   Enter the following for connection string to our source VM, then click **Connect**.

      **Connection string:** +++mongodb://techconnect:Pa$$W0rdMongoDB!@@lab.Variable(MongoDBVMPublicIP):27017/?authMechanism=SCRAM-SHA-256&replicaSet=rs0+++
      **Name:** +++MongoDB VM+++

5. Once connected, the MongoDB VM connection will be visible on the top left. You should see the three system databases along with "prod-db-user1-xxx" that hosts the sales data. Right-click on **MongoDB VM** and select **Manage**.

  //INCLUDE IMAGE

   Select **Azure Cosmos DB Migration** to begin.

   //INCLUDE IMAGE

   On the next screen, select **Assess and Migrate Database(s)**.

   //INCLUDE IMAGE

6. A 7-step migration wizard will appear on the right-hand side of your screen to guide you through the whole migration without needing to run any commands.

   In Step 1, specify +++assessment1+++ for **Assessmnent name**, then click **Run validation**.
   //INCLUDE IMAGE
   //INCLUDE IMAGE
   The validation step ensures that the database user under which we are connecting (as specified earlier in the connection string) has sufficient permissions to execute the migration. After the validation succeeds, click on **Start assessment**.

   Step 2 - a compatibility assessment is automatically launched. This may take a few seconds to complete.
   //INCLUDE IMAGE
   Upon completion, a screen with assessment results will appear.
   //INCLUDE IMAGE
   Our compatibility assessment was succesful, but there are 2 informational warnings and 1 issue noted. Let's examine these closer. Click on **Warning issues** and **Informational Issues** and examine each issue description.
   //INCLUDE IMAGE
   The assessment reports that replSetInitiate command, which is used to initialize a new replica set, is not supported. It won't cause any issues as high availability and replication are fully managed on Azure Cosmos DB for MongoDB vCore. Similarly, you could see that certain commands relating to metrics or logging are unsupported. Azure Cosmos DB for MongoDB vCore exposes metrics and logs through interfaces common to all Azure services; consequently, commands to alter such behavior directly on the database are not supported. Azure Cosmos DB for MongoDB vCore is highly compatible with native MongoDB and most migrations will not experience any compatibility issue.

   Also, worth noting is that only our sales database (prod-db-user1-xxxx) was assessed. The three system databases were not, as they are not required on Azure Cosmos DB for MongoDB vCore. To elaborate further, admin database stores user credentials and credentials are instead managed through Microsoft Entra ID. Config stores, among other things, information about sharding, which is managed by Azure platform. Lastly, local stores information about replication, which is again fully managed for you in Azure.

    As there are no blocking issues, let's proceed further. **Select the tickbox** next to Database, and click **Next** at the bottom of the screen.
   //INCLUDE IMAGE
   
   Step 3 - we now specify the connection to our migration target. As mentioned in the lab intro, an instance of Azure Cosmos DB for MongoDB vCore was pre-provisioned for you. Selections for Subscription, Resource group, and instance should automatically prepopulate. If not, please use available drop downs and make selections as per below screenshot.
//INCLUDE IMAGE

   Specify **Connection string** as follows: +++mongodb+srv://techconnect:XXXXXXXX@techconnect-vcore-1.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000+++
   Next, click **Test connection** to verify connectivity to target instance.

   Next, switch back to MongoDB Compass and let's add the connection to target instance there as well. Click on **+** button next to MongoDB VM.
   //INCLUDE IMAGE

   In the new connection pop up window specify the following:
   **URI:** +++mongodb+srv://techconnect:XXXXXXXX@techconnect-vcore-1.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000+++
   **Name:** +++Azure Cosmos DB for MongoDB vCore+++

   //INCLUDE IMAGE
   Click **Save & Connect** at the bottom right.

   A new pop up will appear informing users that target is an "emulation" of MongoDB. That's correct - Azure Cosmos DB provides wire protocol compatibility with MongoDB databases. Microsoft does not run MongoDB databases to provide this service. Click **Confirm** to proceed.
   //INCLUDE IMAGE

   Let's now return back to Azure Data Studio to continue with the migration.

   We are now at the end of step 3. Click **Next** at the bottom of the screen to proceed.

   Step 4 - In step 4, we are shown a list of all collections that will be migrated. We could selectively exclude certain collections from migration, but in this case, we want to migrate them all. Click **Next** at the bottom of the screen.
   //INCLUDE IMAGE

   Step 5 - In step 5 we create (or select an existing) instance of Azure Database Migration Service. It provides a scalable cloud compute to power data migrations. An instance named dms-mongodb was already pre-created for you.

   Selections for Migration name, Subscription, Resource group, and instance should automatically prepopulate. If not, please use available drop downs and make selections as per below screenshot. Set **Migration mode** as **Offline**. Click **Next** at the bottom of the screen to proceed.
   //INCLUDE IMAGE   

   Step 6 - We are presented with a summary of our choices - collections to be migrated, migration target, and migration mode. Since everything looks correct, let's click on **Create Schema** at the bottom of the page.
   //INCLUDE IMAGE

   Step 7 - Schema was created successfully, and we now have three empty collections (sales, customers, products) on your target Azure Cosmos DB for MongoDB vCore instance.
   //INCLUDE IMAGE

   >[!alert] Do not click to start migration yet!

   As this is offline migration, we now need to take downtime on our application. Let's reconnect to our source VM and stop our application. Switch to Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo systemctl stop new_sales_generator.service+++ and press enter. This will stop our application.
   //INCLUDE IMAGE

   Next, switch to MongoDB Compass. Click on **MongoDB VM**, select **sales** collection and refresh document count. Observe that it doesn't change. Our application is stopped, and we now need to move fast to complete the migration to minimize downtime for users. Let's switch back to Azure Data Studio.

   In Azure Data Studio, at Step 7, click on **Start migration** at the bottom of the screen.

   One more pop up window will appear asking us to verify connectivity. This check is done to ensure the Azure Database Migration service can reach both our source and target servers. Currently, Azure Data Studio migration extension supports only public-endpoint enabled instances. Private endpoint support is coming in Q1 2025. Click on **Check connectivity** and wait a few seconds.
//INCLUDE IMAGE

Finally, click **Continue** to launch the migration.
//INCLUDE IMAGE

7. Our migration is now under way. The migration extension UI reports migration status as "In progress". 
   //INCLUDE IMAGE
   
   In about 2-3 minutes, you should see the status change to "Succeeded". Let's now switch back over to MongoDB Compass to verify the results.
   //INCLUDE IMAGE

   In MongoDB Compass click on **...** next to Azure Cosmos DB for MongoDB vCore and select **Refresh databases**. Our database prod-db-user1-xxxx should now appear. Click on the arrow next to our database to expand collection list. Select **sales** collection. In top right-hand corner take note of the document count.

   //INCLUDE IMAGE

   Now, expand collection list in **MongoDB VM**, select **sales** collection, and verify that the document count matches that of the sales collection in Azure Cosmos DB for MongoDB vCore.

   //INCLUDE IMAGE

    Great! It seems the migration was successful.

8. As a last step, we need to repoint our application to the target database and restart it. Switch to Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo nano /usr/local/bin/new_sales_generator.sh+++ and press enter.
   //INCLUDE IMAGE

   A text editor will open. Use arrow keys to navigate to where MONGO_CONNECTION is defined (line 4). Erase current value and replace it with Azure Cosmos DB for MongoDB vCore connection string by typing +++'mongodb+srv://techconnect:XXXXXXXX@techconnect-vcore-1.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000'+++. Note that single quotes are used to prevent variable expansion.
   //INCLUDE IMAGE

   The result should look as follows:
   //INCLUDE IMAGE

   Next press **Ctrl+X** followed by **Shift+Y** followed by **Enter**. This will save the file.

   Finally, restart our application by typing: +++sudo systemctl start new_sales_generator.service+++ and press enter.
   //INCLUDE IMAGE

   Let's switch over to MongoDB Compass and verify our application is able to write to Azure Cosmos DB for MongoDB vCore. In MongoDB Compass select **Azure Cosmos DB for MongoDB vCore** and click on **sales** collection. Click to refresh the document count in top right-hand corner. After a few seconds refresh again. You should see document count going up.
   //INCLUDE IMAGE

   Congratulations! You've just migrated a self-managed MongoDB VM to an Azure-managed service in offline manner. Now, let's see how this would be different if you had lots of data in your sales database and couldn't afford downtime.
