Function New-SnmpManager {
    <#
        .SYNOPSIS
          Add a server to the PermittedManagers key

        .DESCRIPTION
          This function will add the specified server to the default PermittedManagers SNMP key

        .PARAMETER PermittedManager
          [string] This is where you define the server

        .INPUTS
          None

        .OUTPUTS
          None

        .NOTES
          Version:        1.0
          Author:         Joshua Barton
          Creation Date:  10.11.16
          Purpose/Change: Initial script development
  
        .EXAMPLE
          New-SnmpManager -PermittedManager '192.168.1.1'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$PermittedManager
    )

    # Initialize Variables
    $ManagerKey = 'HKLM:\System\CurrentControlSet\services\SNMP\Parameters\PermittedManagers\'

    # Get current permitted managers
    $KeyProperties = Get-ItemProperty -Path $ManagerKey

    # Helper function to check property names
    $ManagerProperty = Get-SnmpProperty -Property $PermittedManager

    # Check if manager already exists.
    if ($ManagerProperty.Value -ne $PermittedManager) {
        Set-SnmpProperty -RegistryKey $ManagerKey -PropertyName $ManagerProperty.Name -PropertyType String -PropertyValue $PermittedManager
    } else {
        Write-Output "$($ManagerProperty.Value) already exists."
    }
}