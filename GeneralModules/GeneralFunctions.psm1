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
Function Convert-PSOrderedDictionaryArrayToJSON{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSOrderedDictionaryArray
    )
    Begin{}
    Process{      
        $json = $PSOrderedDictionaryArray | ConvertTo-Json 
        return $json
    }
    End{}
}

# Tested OKay
Function Convert-PSOrderedDictionaryArrayToTable{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSOrderedDictionaryArray,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file to export")]
        [String] $PathOfTXT
    )
    Begin{}
    Process{      
        $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize > $PathOfTXT
    }
    End{}
}

# Tested OKay
Function Convert-PSOrderedDictionaryArrayToCSV{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSOrderedDictionaryArray,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file to export")]
        [String] $PathOfCSV
    )
    Begin{}
    Process{   
        $PSCustomObjectArray = $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_}
        Export-PSCustomObjectArrayToCSV -PSCustomObjectArray $PSCustomObjectArray -PathOfCSV  $PathOfCSV 
    }
    End{}
}

Function Convert-PSOrderedDictionaryArrayToPSCustomObjectArray{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSOrderedDictionaryArray
    )
    Begin{}
    Process{   
        $PSCustomObjectArray = $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_}
        return $PSCustomObjectArray 
    }
    End{}
}

Function Export-PSCustomObjectArrayToCSV{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSCustomObjectArray,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file to export")]
        [String] $PathOfCSV
    )
    Begin{}
    Process{      
        $PSCustomObjectArray |Export-Csv $PathOfCSV -NoTypeInformation 
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

function Save-ResultInExpectedFormat{

    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$PSOrderedDictionaryArray,

        [switch]$SaveAsJSON,

        [switch]$SaveAsCSV,

        [switch]$SaveAsTable,

        [Parameter(Mandatory=$True, HelpMessage="Path of output directory where we want to store the results")]
        [String] $PathOfOutputDir
    )
    Begin{}
    Process{
        # Save as JSON if requested
        if ($SaveAsJSON) {
                $json = Convert-PSOrderedDictionaryArrayToJSON -PSOrderedDictionaryArray $PSOrderedDictionaryArray 
                Set-Content -Path "$PathOfOutputDir/ResultAsJSON.json" -Value $json 
        }
        
        # Save as CSV if requested
        if ($SaveAsCSV) {
            Convert-PSOrderedDictionaryArrayToCSV -PSOrderedDictionaryArray $PSOrderedDictionaryArray -PathOfCSV "$PathOfOutputDir/ResultAsCSV.csv"
        }
        
        # Save as Table if requested
        if ($SaveAsTable) {
            Convert-PSOrderedDictionaryArrayToTable -PSOrderedDictionaryArray $PSOrderedDictionaryArray -PathOfTXT "$PathOfOutputDir/ResultAsTABLE.txt"
        }
    }
    End{}
}