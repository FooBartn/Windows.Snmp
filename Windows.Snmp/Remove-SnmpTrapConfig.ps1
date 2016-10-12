Function Remove-SnmpTrapConfig {
    <#
        .SYNOPSIS
          Remove SNMP trap configuration

        .DESCRIPTION
          This function will remove servers from the specified TrapConfiguration sub-key, or the complete sub-key and children
          if no TrapServer is specified

        .PARAMETER TrapName
          [string] Name of the TrapConfiguration sub-key.

        .PARAMETER TrapServer
          [string] Name of the server to remove from the specified trap name

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
          Remove-SnmpTrapConfig -CommunityString 'MyCommunity' -TrapServer '192.168.1.1'
          Remove-SnmpTrapConfig -CommunityString 'MyCommunity'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$CommunityString,

        [Parameter(Mandatory = $False)]
        [String]$TrapServer
    )

    # Initialize Variables
    $TrapKey = "HKLM:\System\CurrentControlSet\services\SNMP\Parameters\TrapConfiguration\$CommunityString"

    # Check if $TrapKey exists.
    # If not, create it.
    if (Test-Path $TrapKey) {
        if ($TrapServer) {
            # Get current trap servers
            $KeyProperties = Get-ItemProperty -Path $TrapKey
        
            # Helper function to check property names
            $TrapProperty = Get-SnmpProperty -Property $TrapServer
        
            # Check to see if $TrapServer exists
            if ($TrapProperty.Value -eq $TrapServer) {
                try {
                    Remove-ItemProperty -Path $TrapKey -Name $TrapProperty.Name -ErrorAction Stop
                    Write-Output "$($TrapProperty.Value) Removed."
                } catch {
                    Write-Error $_.Exception.Message
                }
            } else {
                Write-Output "$TrapServer doesn't exist"
            }
        } else {
            try {
                Remove-Item -Path $TrapKey -Force -ErrorAction Stop
                Write-Output "$TrapKey removed."
            } catch {
                Write-Error $_.Exception.Message
            } 
        }
    }
}