# Set your variables
$keyVaultName = "SQLTestKW"
$resourceGroup = "entraIDSQLTest"
$machineName = "WinSer25DKTP"

# Get the Arc machine's system-assigned managed identity principal ID
$arcMachine = Get-AzConnectedMachine -ResourceGroupName $resourceGroup -Name $machineName
$principalId = $arcMachine.IdentityPrincipalId

Write-Host "Arc Machine Principal ID: $principalId" -ForegroundColor Yellow

# Grant the Arc machine "Key Vault Secrets User" role on the Key Vault
New-AzRoleAssignment -ObjectId $principalId `
    -RoleDefinitionName "Key Vault Secrets User" `
    -Scope "/subscriptions/11e3388f-0f40-489b-801c-ff228736012a/resourceGroups/$resourceGroup/providers/Microsoft.KeyVault/vaults/$keyVaultName"

Write-Host "Permissions granted successfully!" -ForegroundColor Green
