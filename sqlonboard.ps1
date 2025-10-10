param ($servicePrincipalAppId, $servicePrincipalTenantId, $servicePrincipalSecret)

# These settings will be replaced by the portal when the script is generated
$subId = "11e3388f-0f40-489b-801c-ff228736012a"
$tenantId = "8a31a266-d576-48aa-b04b-21033b9db748"
$resourceGroup = "entraIDSQLTest"
$location = "northeurope"
$proxy=""
$licenseType="LicenseOnly"

# These optional variables can be replaced with valid service principal details
# if you would like to use this script for a registration at scale scenario, i.e. run it on multiple machines remotely
# For more information, see https://docs.microsoft.com/sql/sql-server/azure-arc/connect-at-scale
#
# For security purposes, passwords should be stored in encrypted files as secure strings
#
#$servicePrincipalAppId = ''
#$servicePrincipalTenantId = ''
#$servicePrincipalSecret = ''

$currentDir = Get-Location
$unattended = $servicePrincipalAppId -And $servicePrincipalTenantId -And $servicePrincipalSecret

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    if ($proxy) {
		Invoke-WebRequest -Proxy $proxy -Uri https://aka.ms/AzureExtensionForSQLServer -OutFile AzureExtensionForSQLServer.msi
	} else {
		Invoke-WebRequest -Uri https://aka.ms/AzureExtensionForSQLServer -OutFile AzureExtensionForSQLServer.msi
	}
}
catch {
    throw "Invoke-WebRequest failed: $_"
}

try {
	$exitcode = (Start-Process -FilePath msiexec.exe -ArgumentList @("/i", "AzureExtensionForSQLServer.msi","/l*v", "installationlog.txt", "/qn") -Wait -Passthru).ExitCode

	if ($exitcode -ne 0) {
		$message = "Installation failed: Please see $currentDir\installationlog.txt file for more information."
		Write-Host -ForegroundColor red $message
		return
	}

	if ($unattended) {
		& "$env:ProgramW6432\AzureExtensionForSQLServer\AzureExtensionForSQLServer.exe" --subId $subId --resourceGroup $resourceGroup --location $location --tenantid $servicePrincipalTenantId --service-principal-app-id $servicePrincipalAppId --service-principal-secret $servicePrincipalSecret --proxy $proxy --licenseType $licenseType  --tags "SQLExpress=2022" --machineName "SQL2022"
	} else {
		& "$env:ProgramW6432\AzureExtensionForSQLServer\AzureExtensionForSQLServer.exe" --subId $subId --resourceGroup $resourceGroup --location $location --tenantid $tenantId --proxy $proxy --licenseType $licenseType  --tags "SQLExpress=2022" --machineName "SQL2022"
	}

	if($LASTEXITCODE -eq 0){
		Write-Host -ForegroundColor green "Azure extension for SQL Server is successfully installed. If one or more SQL Server instances are up and running on the server, SQL Server enabled by Azure Arc instance resource(s) will be visible within a minute on the portal. Newly installed instances or instances started now will show within an hour."
	}
	else{
		$message = "Failed to install Azure extension for SQL Server. Please see $currentDir\AzureExtensionForSQLServerInstallation.log file for more information."
		Write-Host -ForegroundColor red $message
	}
}
catch {
	Write-Host -ForegroundColor red $_.Exception
	throw
}
