Configuration EdgePolicy {

    Registry Edge {

        Ensure = "Present"

        Key = "HKLM:\Software\Policies\Microsoft\Edge"

        ValueName = "DefaultPluginsSetting"

        ValueData = "2"

        ValueType = "Dword" }

        Registry Edge-2 {

        Ensure = "Present"

        Key = "HKLM:\Software\Policies\Microsoft\Edge"

        ValueName = "ImportHomepage"

        ValueData = "1"

        ValueType = "Dword" }

        Registry Edge-3 {

        Ensure = "Present"

        Key = "HKLM:\Software\Policies\Microsoft\Edge"

        ValueName = "ImportPaymentInfo"

        ValueData = "0"

        ValueType = "Dword" }

        }

        EdgePolicy -output C:\Temp