Function Remove-SnmpManager {
    <#
        .SYNOPSIS
          Remove SNMP manager

        .DESCRIPTION
          This function will remove servers from the specified PermittedManagers key.

        .PARAMETER PermittedManager
          [string] Name of the server to remove from the PermittedManagers key

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
          Remove-SnmpManager -PermittedManager '192.168.1.1'
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
    if ($ManagerProperty.Value -eq $PermittedManager) {
        Remove-ItemProperty -Path $ManagerKey -Name $ManagerProperty.Name -ErrorAction Stop
        Write-Output "$($ManagerProperty.Value) removed."
    } else {
        Write-Output "$PermittedManager doesn't exist."
    }
}