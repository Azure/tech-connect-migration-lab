# MongoDB Lab - Online migration

## Perform offline migration

In this exercise, we will perform an online migration, that is one where application downtime is unacceptable. Online migration is typically used for high-value production systems or systems with significant volume of data.

1. Before we begin, we need to revert the lab environment to state before offline migration. That is, we need to erase any migrated data on the target Azure Cosmos DB for MongoDB vCore, and repoint our application to write into source VM.

   Let's reconnect to our source VM and stop our application. Switch to Edge browser. Your console should still be open and active. If console has disconnected, close it and reconnect.

   In VM console, type +++sudo systemctl stop new_sales_generator.service+++ and press enter. This will stop our application.
   ![console3](./media/console3.png?raw=true) 

