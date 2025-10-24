# ==========================
# Variables - Customize These
# ==========================
$resourceGroup = "entraIDSQLTest"
$machineName   = "WinSer25DKTP"
$vaultName     = "sqltestkw"
$roleName      = "Key Vault Secrets User"

# ==========================
# Step 1. Get Arc Machine Identity Info
# ==========================
Write-Host "Fetching Managed Identity information for the Arc machine..." -ForegroundColor Cyan
$identity = az connectedmachine show `
    -g $resourceGroup `
    -n $machineName `
    --query identity `
    | ConvertFrom-Json

$principalId = $identity.principalId
Write-Host "Principal ID for managed identity: $principalId" -ForegroundColor Green

# ==========================
# Step 2. Get Key Vault Resource ID
# ==========================
Write-Host "Fetching Key Vault resource ID..." -ForegroundColor Cyan
$vaultId = az keyvault show -n $vaultName --query id -o tsv
Write-Host "Key Vault Resource ID: $vaultId" -ForegroundColor Green

# ==========================
# Step 3. Assign 'Key Vault Secrets User' Role to Arc Machine MI
# ==========================
Write-Host "Assigning role '$roleName' to the Arc machine managed identity..." -ForegroundColor Cyan
az role assignment create `
    --assignee-object-id $principalId `
    --assignee-principal-type ServicePrincipal `
    --role $roleName `
    --scope $vaultId `
    | Out-Null

Write-Host "✅ Role assignment completed successfully." -ForegroundColor Green

# ==========================
# Step 4. Verify the Role Assignment
# ==========================
Write-Host "Verifying role assignment..." -ForegroundColor Cyan
az role assignment list `
    --scope $vaultId `
    --assignee $principalId `
    -o table
