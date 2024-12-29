$Params = @{
    ResourceGroupName  = 'tech-connect-mysql-lab'
    VMName             = 'tech-connect-mysql-vm'
    Name               = 'CustomScript'
    Publisher          = 'Microsoft.Azure.Extensions'
    ExtensionType      = 'CustomScript'
    TypeHandlerVersion = '2.1'
    Settings          = @{fileUris = @('https://raw.githubusercontent.com/Azure/tech-connect-migration-lab/refs/heads/main/MySQL/scripts/initmysqlenv.sh'); commandToExecute = 'bash ./initmysqlenv.sh'}
}
Set-AzVMExtension @Params
