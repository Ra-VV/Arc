$kv = Get-AzKeyVault -VaultName sqltestkw

Write-Output "Key Vault Network Settings:"
Write-Output "Public Network Access: $($kv.PublicNetworkAccess)"
Write-Output "Network Rule Set: $($kv.NetworkRuleSet)"

if ($kv.NetworkRuleSet -ne $null) {
    Write-Output "Default Action: $($kv.NetworkRuleSet.DefaultAction)"
    Write-Output "Bypass: $($kv.NetworkRuleSet.Bypass)"
    Write-Output "IP Rules: $($kv.NetworkRuleSet.IpAddressRanges)"
    
    # If network restrictions exist, ensure Azure services are allowed
    if ($kv.NetworkRuleSet.DefaultAction -eq "Deny") {
        Write-Output "WARNING: Key vault has network restrictions that may block Arc service"
    }
}
