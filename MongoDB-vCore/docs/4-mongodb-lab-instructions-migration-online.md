# MongoDB Lab - Online migration

## Perform online migration

In this exercise, we will perform an online migration, that is one where application downtime is not needed. Online migration is typically used for high-value production systems or systems with significant volume of data.

1. Before we begin, we need to revert the lab environment to state before offline migration. That is, we need to erase any migrated data on the target Azure Cosmos DB for MongoDB vCore, and repoint our application to write into source VM.

   Let's reconnect to our source VM and stop our application. Switch to Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo systemctl stop new_sales_generator.service+++ and press enter. This will stop our application.
   ![console3](./media/console3.png?raw=true) 

   Next, type +++sudo nano /usr/local/bin/new_sales_generator.sh+++ and press enter.
   ![console4](./media/console4.png?raw=true)
   
   A text editor will open. Use arrow keys to navigate to where MONGO_CONNECTION is defined (line 4). Erase current value and replace it with source VM MongoDB connection string by typing +++"mongodb://127.0.0.1:27017/?replicaSet=rs0"+++.
   ![console6](./media/console6.png?raw=true)

   The result should look as follows:
   
   ![console5](./media/console5.png?raw=true)   

   Next press **Ctrl+X** followed by **Shift+Y** followed by **Enter**. This will save the file.

   Finally, restart our application by typing: +++sudo systemctl start new_sales_generator.service+++ and press enter.
   ![console7](./media/console7.png?raw=true)

   Let's switch over to MongoDB Compass and verify our application is able to write to source MongoDB VM. In MongoDB Compass select **MongoDB VM** and click on **sales** collection. Click to refresh the document count in top right-hand corner. After a few seconds refresh again. You should see document count going up.
   ![mongodb compass15](./media/mongo%20compass15.png?raw=true)

   Lastly, let's delete the database we migrated to target in previous exercise. In MongoDB Compass select **Azure Cosmos DB for MongoDB vCore** and locate database ending with your username **@lab.CloudPortalCredential(User1).Username**. Click on the trash can icon next to the database name.

   ![mongodb compass17](./media/mongo%20compass17.png?raw=true)

   >[!alert] Ensure you are deleting database ending with your lab username **@lab.CloudPortalCredential(User1).Username**. Other lab users share this server with you and you would end up deleting their work! Please double, triple check.

   A pop up window will appear in the middle of the screen asking you to retype the name of the database to confirm. Please input it and click **Drop Database** in the bottom right-hand corner.
  ![mongodb compass18](./media/mongo%20compass18.png?raw=true)

   A success message should appear at the bottom left and our database should disappear from the list of available databases under Azure Cosmos DB for MongoDB vCore.
   ![mongodb compass19](./media/mongo%20compass19.png?raw=true)
      
   >[!note] You may still see other database listed under Azure Cosmos DB for MongoDB vCore. These belong to other lab users. Please kindly ignore them.

   With that we've successfully reverted the lab environment a state before first migration!

2. Now, let's proceed with online migration. Switch over to **Azure Data Studio**, Microsoft's preferred MongoDB migration tool.

   In Azure Data Studio the MongoDB VM connection should still be visible on the top left. Right-click on **MongoDB VM** and select **Manage**.

  ![ads8](./media/ads8.png?raw=true)

   Select **Azure Cosmos DB Migration** to begin.

   ![ads9](./media/ads9.png?raw=true)

   On the next screen, select **Assess and Migrate Database(s)**.

   ![ads10](./media/ads10.png?raw=true) 

3. A 7-step migration wizard will appear on the right-hand side of your screen to guide you through the whole migration without needing to run any commands.

   In Step 1, specify +++assessment2+++ for **Assessmnent name**, then click **Run validation**, then click **Start assessment**.
   ![ads26](./media/ads26.png?raw=true)
   ![ads27](./media/ads27.png?raw=true)

   Step 2 - a compatibility assessment is automatically launched. This may take a few seconds to complete.
   ![ads28](./media/ads28.png?raw=true)

   As we assessed our server just minutes ago and found no blocking issues, we can safely proceed. **Select the tickbox** next to Database, and click **Next** at the bottom of the screen.

   Step 3 - we now specify the connection to our migration target. Selections for Subscription, Resource group, and instance should automatically prepopulate. If not, please use available drop downs and make selections as per below screenshot.
   ![ads16](./media/ads16.png?raw=true)

   Specify **Connection string** as follows: +++mongodb+srv://techconnect:XXXXXXXX@techconnect-vcore-1.mongocluster.cosmos.azure.com/?tls=true&authMechanism=SCRAM-SHA-256&retrywrites=false&maxIdleTimeMS=120000+++

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
   1. Initial Data Copy: This phase is similar to offline migration, where a simple data copy is performed to migrate historical data. Depending on data volume this may take hours or even days.
   2. Delta Sync: This is where online migration differs. During this phase, MongoDB's [change streams](https://www.mongodb.com/docs/manual/changeStreams/) are used. Change streams are an in-built change data capture mechanism that allows us to replay all writes, updates, and deletes on the target server. This ensures that any changes made during the migration are captured and applied to the target server, preventing data loss. Since phase 1 can take significant amount of time to complete, phase 2 might also require extended time to process all changes that have accumulated during phase 1. Additionally, since swapping the database backend is often considered a high-risk activity, to mitigate potential issues, it's common practice to extend the delta sync period and perform the swap during low-traffic times, such as weekend nights. This approach helps ensure a smoother transition and minimizes the impact on users. It also minimizes disruption in case anything goes amiss and emeregnecy rollback is must be performed.
   3. Cutover: Once the source and target servers are nearly in full sync*, we repoint our application to the target. Technically speaking, in presence of continued writes/updates/deletes on the source server, the target server will always lag behind by a small delta. The idea here is to minimize this delta to seconds, or max few minutes range. Please note that the lowest achievable delta also depends on the given migration tool. Most migration tools synchronize changes from source to target in microbatches that may execute only every few seconds or perhaps every minute to reduce strain on source server. Once delta is minimized, we face a decision

Prior to reporting we may choose to briefly (~1 minute) stop our application and verify document counts match on both servers, but it is not required. In this lab, ... 


   Click on **Start migration** at the bottom of the screen.
   
   >[!note] Unlike in previous migration attempt, this time we are leaving our application running. Our users can continue placing orders on our website all the while we are upgrading our database backend.
   
   One more pop up window will appear asking us to verify connectivity. This check is done to ensure the Azure Database Migration service can reach both our source and target servers. Click on **Check connectivity** and wait a few seconds.
  ![ads22](./media/ads22.png?raw=true)

   Finally, click **Continue** to launch the online migration.
   ![ads23](./media/ads23.png?raw=true)

5. Our migration is now under way. The migration extension UI reports migration status as "In progress". 
   ![ads31](./media/ads31.png?raw=true)

   
