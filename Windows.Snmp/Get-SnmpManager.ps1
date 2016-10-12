Function Get-SnmpManager {
    <#
        .SYNOPSIS
          Get all current SNMP Permitted Managers

        .DESCRIPTION
          This function will retrieve all SNMP Permitted Managers and their index value

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
          Get-SnmpManager
    #>
    [CmdletBinding()]

    # Initialize Variables
    $SnmpManager = '' | Select Index, PermittedManager
    $ManagerKey = 'HKLM:\System\CurrentControlSet\services\SNMP\Parameters\PermittedManagers\'
    $ExcludedProps = @( 'PSPath',
                        'PSParentPath',
                        'PSChildName',
                        'PSDrive',
                        'PSProvider')
    try {
        # Get current permitted managers
        $KeyProperties = Get-ItemProperty -Path $ManagerKey -ErrorAction Stop | Select * -Exclude $ExcludedProps
        
        # Output
        foreach ($KeyProperty in $KeyProperties.PSObject.Properties) {
            $SnmpManager.Index = $KeyProperty.Name
            $SnmpManager.PermittedManager = $KeyProperty.Value

            $SnmpManager
        }
    } catch [System.Management.Automation.ItemNotFoundException] {
        Write-Error "$ManagerKey does not exist. Check that SNMP is installed."
    }
}