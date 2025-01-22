# MongoDB Lab - Online migration

## Perform offline migration

In this exercise, we will perform an online migration, that is one where application downtime is unacceptable. Online migration is typically used for high-value production systems or systems with significant volume of data.

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

   [!alert] Ensure you are deleting database ending with your lab username **@lab.CloudPortalCredential(User1).Username**. Other lab users share this server with you and you would end up deleting their work! Please double, triple check.

   A pop up window will appear in the middle of the screen asking you to retype the name of the database to confirm. Please input it and click **Drop Database** in the bottom right-hand corner.
  ![mongodb compass18](./media/mongo%20compass18.png?raw=true)

   A success message should appear at the bottom left and our database should disappear from the list of available databases under Azure Cosmos DB for MongoDB vCore.
   ![mongodb compass19](./media/mongo%20compass19.png?raw=true)
      
   [!note] You may still see other database listed under Azure Cosmos DB for MongoDB vCore. These belong to other lab users. Please kindly ignore them.

   With that we've successfully reverted the lab environment a state before first migration!

3. Now, let's proceed with online migration.
