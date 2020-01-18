# Tested OKay
Function Get-UniquePhoneNumbers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String] $ColumnName
    )
    Begin{}
    Process{
        return Get-GroupValuesForACSVColumn -PathOfCSV "$PathOfCSV" -ColumnName "$ColumnName" -Attribute "Name"      
    }
    End{}
}

# Tested OKay
Function Get-CallFrequency{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String] $ColumnName
    )
    Begin{}
    Process{
        return Get-GroupValuesForACSVColumn -PathOfCSV "$PathOfCSV" -ColumnName "$ColumnName" -Attribute "Count"      
    }
    End{}
}

# Tested OKay
Function Set-CallStatistics{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String[]] $PhoneNumbers,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String[]] $CallFrequency 
    )
    Begin{}
    Process{
        $PSObjectArray = for($i = 0; $i -lt $PhoneNumbers.Count; $i++){
            [psobject][ordered]@{
                'PhoneNumber' = $PhoneNumbers[$i];
                'CallFrequency' = $CallFrequency[$i]
                }
        }
        
        return $PSObjectArray 
    }
    End{}
}