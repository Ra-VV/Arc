# Run this in PowerShell as Administrator

# Define the instance name
$instanceName = "SQLEXPRESS"

# Registry path for the SQL Server instance
$registryPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.$instanceName\MSSQLServer"

# Check if the registry path exists
if (Test-Path $registryPath) {
    Write-Host "Found SQL Server instance registry path" -ForegroundColor Green
    
    # Add the Azure AD authentication registry values
    # These enable Entra authentication for the instance
    New-ItemProperty -Path $registryPath -Name "AzureADAuthority" -Value "https://login.microsoftonline.com/" -PropertyType String -Force
    
    New-ItemProperty -Path $registryPath -Name "AzureADResource" -Value "https://database.windows.net/" -PropertyType String -Force
    
    Write-Host "Registry values added successfully!" -ForegroundColor Green
    Write-Host "You must restart the SQL Server service for changes to take effect" -ForegroundColor Yellow
    
} else {
    Write-Host "Registry path not found. Let me search for the correct path..." -ForegroundColor Yellow
    
    # Search for the correct instance path
    $sqlServerPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server"
    Get-ChildItem -Path $sqlServerPath | Where-Object {$_.Name -like "*MSSQL*$instanceName*"}
}
