# MongoDB Lab - Offline migration

## Perform offline migration

In this step, we will attempt the more traditional migration approach - offline - that is one where application downtime is necessary. Such approach is suitable for migration of smaller volumes of data and/or for non-critical systems where downtime is acceptable (e.g., an internal-facing app is taken offline for a few hours on a Saturday night).

1. Minimize any open application windows and launch **Azure Data Studio**, which is pre-installed for you on the Desktop. As mentioned earlier, Azure Data Studio is Microsoft's preferred tool for executing MongoDB migrations.
   //INCLUDE IMAGE

2. Once Data Studio launches, **click on the person icon** in the bottom left-hand corner.
   //INCLUDE IMAGE

   A pop up window will appear on the right-hand side of your screen. Click on **Add an account**.

   //INCLUDE IMAGE

   Doing so will open the Edge browser and prompt you to log in. Select **Use another account** and enter the following:

   //INCLUDE IMAGE

    **Username:** +++User1-47490180@LODSPRODMCA.onmicrosoft.com+++
    **Password:** +++XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX+++

    >[!alert] Do not select the already signed in account. If you by accident select the existing account, return to Data Studio, remove the account and repeat this step.

    >[!note] Here, were are selecting different user account as the target - Azure Cosmos DB MongoDB vCore - database is provisioned in a different Azure environment, one that your lab user does not have permissions over.

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

   Step 5 - In step 5
   
   
