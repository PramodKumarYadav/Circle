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
Function Export-PSObjectArrayToCSV{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSObjectArray,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file to export")]
        [String] $PathOfCSV
    )
    Begin{}
    Process{      
        $PSObjectArray | Export-Csv $PathOfCSV -NoTypeInformation
    }
    End{}
}

# Not yet tested 
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