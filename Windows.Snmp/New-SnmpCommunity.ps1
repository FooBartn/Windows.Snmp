Function New-SnmpCommunity {
    <#
        .SYNOPSIS
          Add a community string to the ValidCommunities key

        .DESCRIPTION
          This function will add the specified community string to the default ValidCommunities SNMP key

        .PARAMETER CommunityString
          [string] This is where you define the string name

        .PARAMETER Permissions
          [string] This is where you define the community string permissions.
          Accepted Values: Read-Only, Read-Write, or No-Access

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
          New-SnmpCommunity -CommunityString 'MyCommunity' -Permission 'Read-Only'
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True)]
        [String]$CommunityString,

        [Parameter(Mandatory = $True)]
        [ValidateSet('Read-Only','Read-Write','No-Access')]
        $Permissions
    )

    # Initialize Variables
    $CommunityKey = 'HKLM:\System\CurrentControlSet\services\SNMP\Parameters\ValidCommunities\'

    # Change permission into correct dword value
    switch ($Permissions)
    {
        'Read-Only' {
            $PermissionValue = 4
        }

        'Read-Write' {
            $PermissionValue = 8
        }

        'No-Access' {
            $PermissionValue = 1
        }
    }

    # Get the current key properties
    $KeyProperties = Get-ItemProperty -Path $CommunityKey

    # Check to see if community string already exists
    # If not, create it.
    if (!($KeyProperties.$CommunityString)) {
        Set-SnmpProperty -RegistryKey $CommunityKey -PropertyName $CommunityString -PropertyType Dword -PropertyValue $PermissionValue
        Write-Output "$CommunityString added."
    } else {
        Write-Output "$CommunityString already exists."
    }
}