Function New-SnmpTrapConfig {
    <#
        .SYNOPSIS
          Add a new SNMP trap configuration

        .DESCRIPTION
          This function will add servers to the specified TrapConfiguration sub-key, creating that key if necessary.

        .PARAMETER TrapName
          [string] Name of the TrapConfiguration sub-key.

        .PARAMETER TrapServer
          [string] Name of the server to add to the specified trap name

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
          New-SnmpTrapConfig -CommunityString 'MyCommunity' -TrapServer '192.168.1.1'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$CommunityString,

        [Parameter(Mandatory = $True)]
        [String]$TrapServer
    )

    # Initialize Variables
    $TrapKey = "HKLM:\System\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\$CommunityString"

    # Check if $TrapKey exists.
    # If not, create it.
    if (!(Test-Path $TrapKey)) {
         try {
            New-Item -Path $TrapKey -Force -ErrorAction Stop
            
            # Get current trap servers
            $KeyProperties = Get-ItemProperty -Path $TrapKey

            # Helper function to check property names
            $TrapProperty = Get-SnmpProperty -Property $TrapServer

            if ($TrapProperty.Value -ne $TrapServer) {
                Set-SnmpProperty -RegistryKey $TrapKey -PropertyName $TrapProperty.Name -PropertyType String -PropertyValue $TrapServer
            } else {
                Write-Output "$($TrapProperty.Value) already exists."
            }
        } catch {
            Write-Output $_.Exception.Message
        }
    }
}