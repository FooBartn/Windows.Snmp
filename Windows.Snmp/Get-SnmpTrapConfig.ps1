Function Get-SnmpTrapConfig {
    <#
        .SYNOPSIS
          Get existing SNMP Trap configurations

        .DESCRIPTION
          This function will retrieve existing SNMP Trap configurations and output them as an object

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
          Get-SnmpTrapConfig
    #>
    [CmdletBinding()]

 
    # Initialize Variables
    $TrapConfigKey = "HKLM:\System\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\"
    $ExcludedProps = @( 'PSPath',
                        'PSParentPath',
                        'PSChildName',
                        'PSDrive',
                        'PSProvider')

    try {
        $SnmpTrapKeys = (Get-ChildItem $TrapConfigKey -ErrorAction Stop).Name
        foreach ($SnmpTrapKey in $SnmpTrapKeys) {
            # Initialize custom object
            $SnmpTrap = [PSCustomObject]@{
                Community = ''
                TrapServers = @(
                )
            }

            # Reformat key path for Get-ItemProperty and gather SNMP Traps
            $SnmpTrapKey = $SnmpTrapKey -replace 'HKEY_LOCAL_MACHINE','HKLM:'
            $TrapConfig = Get-ItemProperty $SnmpTrapKey | Select-Object * -Exclude $ExcludedProps
            $SnmpTrap.Community = $SnmpTrapKey.Split('\') | Select -Last 1
            
            # Add servers to TrapServers array inside SnmpTrap object
            foreach ($TrapServer in $TrapConfig.PSObject.Properties) {
                $SnmpTrap.TrapServers += $TrapServer.Value
            }

            $SnmpTrap
        }
    } catch [System.Management.Automation.ItemNotFoundException] {
        Write-Error "$TrapConfigKey does not exist. Check that SNMP is installed."
    }
}