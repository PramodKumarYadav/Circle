# Tested OKay
Function Get-GroupValuesForACSVColumn{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String] $ColumnName,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String] $Attribute
    )
    Begin{}
    Process{
        $csvGroup = Import-Csv $PathOfCSV | Group-Object {$_.$ColumnName}
        $values = @()
        foreach($group in $csvGroup){
            $values += $group.$Attribute
        }

        return $values       
    }
    End{}
}

Function Set-CallStatistics2{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String[]] $PhoneNumbers,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String[]] $CallFrequency 
    )
    Begin{}
    Process{
        $PSObjectArray = @()

        for($i = 0; $i -lt $PhoneNumbers.Count; $i++){
            $PSitem = [psobject][ordered]@{
                        'PhoneNumber' = $PhoneNumbers[$i];
                        'CallFrequency' = $CallFrequency[$i]
                        }
            $PSObjectArray += $PSitem
        }
        
        return $PSObjectArray 
    }
    End{}
}

# Tested OKay
Function Convert-PSObjectArrayToJSON{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSObjectArray
    )
    Begin{}
    Process{      
        $json = $PSObjectArray | ConvertTo-Json 
        return $json
    }
    End{}
}

# Tested OKay
Function Convert-PSObjectArrayToCSV{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSObjectArray
    )
    Begin{}
    Process{      
        $csv = $PSObjectArray | ConvertTo-Csv -NoTypeInformation
        return $csv 
    }
    End{}
}

Function Convert-PSObjectArrayToXML{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSObjectArray
    )
    Begin{}
    Process{      
        $xml = $PSObjectArray | ConvertTo-Xml -NoTypeInformation 
        return $xml 
    }
    End{}
}