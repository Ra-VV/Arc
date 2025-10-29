Write-Host "=== TEST ENDPOINTOW AZURE ARC ===" -ForegroundColor Yellow

$arcEndpoints = @(
    @{Name = "his-arc.northeurope.arcdataservices.com"; Description = "HIS - Hosted Instance Service"},
    @{Name = "telemetry.northeurope.arcdataservices.com"; Description = "Telemetria"},
    @{Name = "login.microsoftonline.com"; Description = "Azure AD Authentication"},
    @{Name = "sqltestcarano.vault.azure.net"; Description = "Key Vault"},
    @{Name = "20.50.224.33"; Description = "HIS IP (northeurope)"},
    @{Name = "20.50.120.84"; Description = "Telemetry IP (northeurope)"}
)

foreach ($endpoint in $arcEndpoints) {
    $result = Test-NetConnection -ComputerName $endpoint.Name -Port 443 -WarningAction SilentlyContinue

    if ($result.TcpTestSucceeded) {
        $status = "GOOD"
        $color = "Green"
    } else {
        $status = "BAD"
        $color = "Red"
    }

    Write-Host "$status : $($endpoint.Name)" -ForegroundColor $color
    Write-Host "      Opis: $($endpoint.Description)" -ForegroundColor Gray
    Write-Host ""
}
