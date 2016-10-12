Function Get-SnmpProperty ($Property) {
    <#
        Helper for New-SnmpManager, New-SnmpTrapConfig, and Remove-SnmpTrapConfig
        Searches for existing properties
        Also finds the next available numerical property name.
    #>

    $SnmpProperty = '' | Select Name,Value
    if ($Property) {
        if ($KeyProperties.PSObject.Properties.Value -Contains $Property) {
            foreach ($PropertyName in $KeyProperties.PSObject.Properties.Name) {
                if ($KeyProperties.$Propertyname -eq $Property) {
                    $SnmpProperty.Name = $PropertyName
                    $SnmpProperty.Value = $KeyProperties.$PropertyName
                    break
                }
            }
        } else {
            $PropertyName = 0

            do {
                $PropertyName++  
            } until (!($KeyProperties.$PropertyName))

            $SnmpProperty.Name = $PropertyName
        }
    } else {
        $SnmpProperty.Name = 1
    }

    $SnmpProperty
}