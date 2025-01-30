# MongoDB Lab - Online migration

## Perform online migration

In this exercise, we will perform an online migration, that is one where application downtime is not needed. Online migration is typically used for high-value production systems or systems with significant volume of data.

1. Before we begin, we need to revert the lab environment to the state before offline migration. That is, we need to erase any migrated data on the target Azure Cosmos DB for MongoDB vCore, and repoint our application to write into source VM.

   Let's reconnect to our source VM and stop our application. Switch to the Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo systemctl stop new_sales_generator.service+++ and press enter. This will stop our application.
   ![console3](./media/console3.png?raw=true) 

   Next, type +++sudo nano /usr/local/bin/new_sales_generator.sh+++ and press enter.
   ![console4](./media/console4.png?raw=true)
   
   A text editor will open. Use arrow keys to navigate to where MONGO_CONNECTION is defined (line 4). Erase current value and replace it with the source VM MongoDB connection string by typing +++"mongodb://127.0.0.1:27017/?replicaSet=rs0"+++.
   ![console6](./media/console6.png?raw=true)

   The result should look as follows:
   
   ![console5](./media/console5.png?raw=true)   

   Next press **Ctrl+X** followed by **Shift+Y** followed by **Enter**. This will save the file.

   Finally, restart our application by typing: +++sudo systemctl start new_sales_generator.service+++ and press enter.
   ![console7](./media/console7.png?raw=true)

   Let's switch over to the MongoDB Compass and verify our application is able to write to source MongoDB VM. In MongoDB Compass select **MongoDB VM** and click on **sales** collection. Click to refresh the document count in top right-hand corner. After a few seconds refresh again. You should see document count going up.
   ![mongodb compass15](./media/mongo%20compass15.png?raw=true)

   Lastly, let's delete the database we migrated to target in the previous exercise. In MongoDB Compass select **Azure Cosmos DB for MongoDB vCore** and locate database **prod-db-user1-@lab.LabInstance.Id**. Click on the trash can icon next to the database name.

   ![mongodb compass17](./media/mongo%20compass17.png?raw=true)


    >[!alert] Ensure you are deleting database ending with your lab username **@lab.LabInstance.Id**. Other lab users share this server with you and you would end up deleting their work! Please double, triple check.

   A pop-up window will appear in the middle of the screen asking you to retype the name of the database to confirm. Please input **+++prod-db-user1-@lab.LabInstance.Id+++** and click **Drop Database** in the bottom right-hand corner.
  ![mongodb compass18](./media/mongo%20compass18.png?raw=true)

   A success message should appear at the bottom left and our database should disappear from the list of available databases under Azure Cosmos DB for MongoDB vCore.
   ![mongodb compass19](./media/mongo%20compass19.png?raw=true)
      

    >[!note] You may still see other databases listed under Azure Cosmos DB for MongoDB vCore. These belong to other lab users. Please kindly ignore them.

   With that we've successfully reverted the lab environment the state before the first migration!

2. Now, let's proceed with online migration. Switch over to **Azure Data Studio**, Microsoft's preferred MongoDB migration tool.

   In Azure Data Studio the MongoDB VM connection should still be visible on the top left. Right-click on **MongoDB VM** and select **Manage**.

  ![ads8](./media/ads8.png?raw=true)

   Select **Azure Cosmos DB Migration** to begin.

   ![ads9](./media/ads9.png?raw=true)

   On the next screen, select **Assess and Migrate Database(s)**.

   ![ads10](./media/ads10.png?raw=true) 

3. A 7-step migration wizard will appear on the right-hand side of your screen to guide you through the whole migration without needing to run any commands.

   In Step 1, specify +++onl-@lab.LabInstance.Id+++ for **Assessment name**, then click **Run validation**, then click **Start assessment**.
   ![ads26](./media/ads26.png?raw=true)
   ![ads27](./media/ads27.png?raw=true)

   Step 2 - a compatibility assessment is automatically launched. This may take a few seconds to complete.
   ![ads28](./media/ads28.png?raw=true)

   As we assessed our server just minutes ago and found no blocking issues, we can safely proceed. **Select the tickbox** next to Database, and click **Next** at the bottom of the screen.

   Step 3 - we now specify the connection to our migration target. Selections for Subscription, Resource group, and instance should automatically prepopulate. If not, please use available drop-downs and make selections as per below screenshot.
   ![ads16](./media/ads16.png?raw=true)

   Specify **Connection string** as follows: +++mongodb+srv://@lab.Variable(CosmosDBUsername):@lab.Variable(CosmosDBPassword)@@lab.Variable(CosmosDBServername).mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000+++

   Next, click **Test connection** to verify connectivity to target instance. Then click **Next** at the bottom of the screen to proceed.

   Step 4 - In step 4, we are shown a list of all collections that will be migrated. We could selectively exclude certain collections from migration, but in this case, we want to migrate them all. Click **Next** at the bottom of the screen.
   ![ads17](./media/ads17.png?raw=true)

   Step 5 - In step 5 we create (or select an existing) instance of Azure Database Migration Service. It provides a scalable cloud compute to power data migrations. An instance named dms-mongodb was already pre-created for you.

   Selections for Migration name, Subscription, Resource group, and instance should automatically prepopulate. If not, please use available drop downs and make selections as per below screenshot. Set **Migration mode** as **Online**. Click **Next** at the bottom of the screen to proceed.
   ![ads29](./media/ads29.png?raw=true)

   Step 6 - We are presented with a summary of our choices - collections to be migrated, migration target, and migration mode, which is set to Online. Since everything looks correct, let's click on **Create Schema** at the bottom of the page.
   ![ads30](./media/ads30.png?raw=true)

   Step 7 - Schema was created successfully, and we now have three empty collections (sales, customers, products) on our target Azure Cosmos DB for MongoDB vCore instance.
   ![ads20](./media/ads20.png?raw=true)

   Up until now, the steps were exactly the same as in previous exercise, where we performed an offline copy. There the process involved stopping our application, performing a simple data copy, and restarting our application with connection string pointing to migration target. All data up until the start of the migration was copied. If we had not stopped the application, any updates that happened during the data copy would have been lost.

   Online migration, on the other hand, consists of three phases:
   1. Initial Data Copy: This phase is similar to offline migration, where a simple data copy is performed to migrate historical data. Depending on the data volume, this may take hours or even days.
   2. Delta Sync: This is where online migration differs. During this phase, MongoDB's [change streams](https://www.mongodb.com/docs/manual/changeStreams/) are used. Change streams are an in-built change data capture mechanism that allows us to replay all writes, updates, and deletes on the target server. This ensures that any changes made during the migration are captured and applied to the target server, preventing data loss. Since phase 1 can take a significant amount of time to complete, phase 2 might also require extended time to process all changes that have accumulated during phase 1. Additionally, since swapping the database backend is often considered a high-risk activity, to mitigate potential issues, it's common practice to extend the delta sync period and perform the swap during low-traffic times, such as weekend nights. This approach helps ensure a smoother transition and minimizes the impact on users. It also minimizes disruption in case anything goes amiss and an emergency rollback must be performed.
   3. Cutover: Once the source and target servers are nearly in full sync, we repoint our application to the target. Technically speaking, in the presence of continued writes/updates/deletes on the source server, the target server will always lag behind by a small delta. The idea here is to minimize this delta to seconds, or at most a few minutes. Please note that the lowest achievable delta also depends on the given migration tool. Most migration tools synchronize changes from source to target in microbatches that may execute only every few seconds or perhaps every minute to reduce strain on the source server. Once the delta is minimized, and we are ready to proceed with the swap, we have two options or tradeoffs:
       1. We may prioritize full safety and data consistency. In such a case, we would stop our application for a very brief moment (~1 minute), wait for the latest changes to synchronize to the target (should only take some seconds as per the frequency of microbatching), verify document counts match on the source and target, and repoint our application.
       2. We may prioritize uptime. In such a case, we perform a rolling upgrade and bring up a new instance of our application with the connection string pointing to the target server while gradually draining connections to the existing instance of our application which points to source server. This approach can achieve zero downtime, but it makes it harder to reason about the consistency of data during the cutover as well as execute a rollback, if needed.

   
    >[!note]  Unlike in the previous migration attempt, this time we are leaving our application running. Our users can continue placing orders on our website all the while we are upgrading our database backend. In this lab, When the time to perform a cutover comes we will choose to execute the simpler cutover and stop our app for a very brief moment to verify data is fully in sync on both servers. We see this approach to be much more prevalent in actual migration scenarios as most systems can tolerate very very brief downtime. Please note the fact that we take a minute (or so) of downtime doesn't equate this approach to that of offline migration. With actual offline migration like we performed in previous exercise we would need to endure downtime equal to duration of initial data copy, which for very large databases can be measured on the order of days.

   Click on **Start migration** at the bottom of the screen to proceed.
      
   One more pop up window will appear asking us to verify connectivity. This check is done to ensure the Azure Database Migration service can reach both our source and target servers. Click on **Check connectivity** and wait a few seconds.
  ![ads22](./media/ads22.png?raw=true)

   Finally, click **Continue** to launch the online migration.
   ![ads23](./media/ads23.png?raw=true)

5. Our migration is now under way. The migration extension UI reports migration status as "In progress". Click on **onl-@lab.LabInstance.Id** to view detailed migration status. 
   ![ads31](./media/ads31.png?raw=true)

   At first, our copy job will report as queued, but within few minutes we should see that phase 1 - initial data copy - is complete, and that phase 2 has begun.
   ![ads32](./media/ads32.png?raw=true)
   ![ads33](./media/ads33.png?raw=true)

   Note, that document count in changes replayed column keeps increasing. The Azure Data Studio migration extension performs a microbatch about every minute or two, so it might take a short while before you see the count go up.
   ![ads34](./media/ads34.png?raw=true)

   As we are dealing with very small volumes of data in this lab, our replication lag ("delta") is immediately minimized and we are now ready to move on. Let's now quickly shut off and repoint our application, while also verifying data consistency.

   Switch to Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo systemctl stop new_sales_generator.service+++ and press enter. This will stop our application.
   ![console3](./media/console3.png?raw=true)

   Next, switch to MongoDB Compass. Click on **MongoDB VM**, select **sales** collection and refresh the document count. Take a note of the count and also observe that it doesn't change. Our application is stopped, and we now need to move fast to complete the migration to minimize downtime for users.
   ![mongodb compass12](./media/mongo%20compass12.png?raw=true)

   Next, click on **...** next to Azure Cosmos DB for MongoDB vCore and select **Refresh databases**.
   ![mongodb compass13](./media/mongo%20compass13.png?raw=true)

   Our database **prod-db-user1-@lab.LabInstance.Id** should now appear. Click on the arrow next to our database to expand collection list. Select **sales** collection. In top right-hand corner take note of the document count. Check that it matches count seen on MongoDB VM.
   ![mongodb compass14](./media/mongo%20compass14.png?raw=true)

   Great! The document counts match, source and target are in sync. Let's now quickly repoint our app and bring it back online.

   Switch back to Edge browser. In VM console, type +++sudo nano /usr/local/bin/new_sales_generator.sh+++ and press enter.
   ![console4](./media/console4.png?raw=true)

   A text editor will open. Use arrow keys to navigate to where MONGO_CONNECTION is defined (line 4). Erase current value and replace it with Azure Cosmos DB for MongoDB vCore connection string by typing +++'mongodb+srv://@lab.Variable(CosmosDBUsername):@lab.Variable(CosmosDBPassword)@@lab.Variable(CosmosDBServername).mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000'+++. Note that single quotes are used to prevent variable expansion.
   ![console5](./media/console5.png?raw=true)

   The result should look as follows:
   ![console6](./media/console6.png?raw=true)

   Next press **Ctrl+X** followed by **Shift+Y** followed by **Enter**. This will save the file.

   Finally, restart our application by typing: +++sudo systemctl start new_sales_generator.service+++ and press enter.
   ![console7](./media/console7.png?raw=true)

   Let's switch over to MongoDB Compass and verify our application is able to write to Azure Cosmos DB for MongoDB vCore. In MongoDB Compass select **Azure Cosmos DB for MongoDB vCore** and click on **sales** collection. Click to refresh the document count in top right-hand corner. After a few seconds refresh again. You should see document count going up. Great that means our users are able to place orders again.
   ![mongodb compass16](./media/mongo%20compass16.png?raw=true)

   As the very last step, we need to stop the delta sync, which is no longer needed. Switch back to Azure Data Studio. The **onl-@lab.LabInstance.Id** migration detail page should still be open. If not, please re-open it. At the top select **Cutover**. 
   ![ads35](./media/ads35.png?raw=true)

   A pop-up will appear with instructions on how to complete the cutover. This is a repeat of the steps we have just completed. Select the **tickbox** to acknowledge and click **Confirm cutover**.
   ![ads36](./media/ads36.png?raw=true)

   It may take some more minutes, but eventually the UI will report migration status as completed. You do not need to wait until it happens. 
   ![ads37](./media/ads37.png?raw=true)

   Congratulations! You've just migrated a self-managed MongoDB VM to an Azure-managed service in an online manner. While we dealt only with a small volume of data, the exact same steps would be followed for migration of large production system.
