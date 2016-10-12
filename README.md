## Windows.Snmp

A set of functions for managing SNMP via PowerShell

Includes:

### Get-SnmpCommunity
This function will retrieve all of the current community strings and convert their dword permissions
into human-readable context

### Get-SnmpManager
This function will retrieve all SNMP Permitted Managers and their index value

### Get-SnmpTrapConfig
This function will retrieve existing SNMP Trap configurations

### New-SnmpCommunity
This function will add the specified community string to the default ValidCommunities SNMP key

### New-SnmpManager
This function will add the specified server to the default PermittedManagers SNMP key

### New-SnmpTrapConfig
This function will add servers to the specified TrapConfiguration sub-key, creating that key if necessary.

### Remove-SnmpManager
This function will remove servers from the specified PermittedManagers key.

### Remove-SnmpTrapConfig
This function will remove servers from the specified TrapConfiguration sub-key, or the complete sub-key and children,
if no TrapServer is specified