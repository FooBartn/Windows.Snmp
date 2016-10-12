Function Set-SnmpProperty
{
    param(
        [String]$RegistryKey,
        [String]$PropertyName,
        [String]$PropertyType,
        [String]$PropertyValue
    )

    try {
        New-ItemProperty -Path $RegistryKey -Name $PropertyName -PropertyType $PropertyType -Value $PropertyValue -ErrorAction Stop
        Write-Output "$PropertyValue added."
    } catch {
        Write-Output $_.Exception.Message
    }
}