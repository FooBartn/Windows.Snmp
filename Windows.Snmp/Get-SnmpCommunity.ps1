Function Get-SnmpCommunity {
    <#
        .SYNOPSIS
          Get all SNMP community strings with permission

        .DESCRIPTION
          This function will retrieve all of the current community strings and convert their dword permissions
          into human-readable context

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
          Get-SnmpCommunity
    #>
    [CmdletBinding()]

    # Initialize Variables
    $SnmpCommunity = '' | Select Community, Permission
    $CommunityKey = 'HKLM:\System\CurrentControlSet\services\SNMP\Parameters\ValidCommunities\'
    $ExcludedProps = @( 'PSPath',
                        'PSParentPath',
                        'PSChildName',
                        'PSDrive',
                        'PSProvider')

    # Get the current key properties
    try {
        $KeyProperties = Get-ItemProperty -Path $CommunityKey -ErrorAction Stop | Select * -Exclude $ExcludedProps

        # Change dword value into human-readable permissions
        foreach ($KeyProperty in $KeyProperties.PSObject.Properties) {
            $SnmpCommunity.Community = $KeyProperty.Name
            Switch ($KeyProperty.Value) {
                4 {
                    $SnmpCommunity.Permission = 'Read-Only'
                }

                8 {
                    $SnmpCommunity.Permission = 'Read-Write'
                }

                1 {
                    $SnmpCommunity.Permission = 'No-Access'
                }
            }

            $SnmpCommunity
        }
    } catch [System.Management.Automation.ItemNotFoundException] {
        Write-Error "$CommunityKey does not exist. Check that SNMP is installed."
    }   
}