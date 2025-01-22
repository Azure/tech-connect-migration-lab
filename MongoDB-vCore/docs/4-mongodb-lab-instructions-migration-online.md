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

2. XXX
