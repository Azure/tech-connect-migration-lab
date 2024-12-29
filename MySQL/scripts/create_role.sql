CREATE USER 'mysqldba'@'%' IDENTIFIED WITH mysql_native_password BY 'Pa$$w0rd!';
GRANT ALL ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT ALTER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT ALTER ROUTINE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE ROLE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE ROUTINE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE TABLESPACE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE TEMPORARY TABLES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE USER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CREATE VIEW ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT DELETE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT DROP ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT DROP ROLE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT EVENT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT EXECUTE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FILE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT GRANT OPTION ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT INDEX ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT INSERT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT LOCK TABLES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT PROCESS ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT REFERENCES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT RELOAD ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT REPLICATION CLIENT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT REPLICATION SLAVE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SELECT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SHOW DATABASES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SHOW VIEW ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SHUTDOWN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SUPER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT TRIGGER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT UPDATE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT USAGE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT APPLICATION_PASSWORD_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT AUDIT_ABORT_EXEMPT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT AUDIT_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT AUTHENTICATION_POLICY_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT BACKUP_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT BINLOG_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT BINLOG_ENCRYPTION_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CLONE_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT CONNECTION_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT ENCRYPTION_KEY_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FIREWALL_EXEMPT ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FLUSH_OPTIMIZER_COSTS ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FLUSH_STATUS ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FLUSH_TABLES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT FLUSH_USER_RESOURCES ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT GROUP_REPLICATION_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT GROUP_REPLICATION_STREAM ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT INNODB_REDO_LOG_ARCHIVE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT INNODB_REDO_LOG_ENABLE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT PERSIST_RO_VARIABLES_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT REPLICATION_APPLIER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT REPLICATION_SLAVE_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT RESOURCE_GROUP_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT RESOURCE_GROUP_USER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT ROLE_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SENSITIVE_VARIABLES_OBSERVER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SESSION_VARIABLES_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SET_USER_ID ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SHOW_ROUTINE ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SYSTEM_USER ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT SYSTEM_VARIABLES_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT TABLE_ENCRYPTION_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;
GRANT TELEMETRY_LOG_ADMIN ON *.* TO 'mysqldba'@'%'  WITH GRANT OPTION;