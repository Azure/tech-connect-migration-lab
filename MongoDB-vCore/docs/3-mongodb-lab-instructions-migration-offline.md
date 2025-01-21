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
