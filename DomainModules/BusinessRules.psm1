Function Get-VoiceRecords{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains all logs (Data/Voice)")]
        [String] $PathOfInputCSV,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains Only Voice logs and relevant columns")]
        [String] $PathOfOutputCSV,

        [Parameter(Mandatory=$True, HelpMessage="Column name to Filter Voice records")]
        [String[]] $FilterColumnName,

        [Parameter(Mandatory=$True, HelpMessage="Column value to Filter Voice records")]
        [String[]] $FilterRowValue,

        [Parameter(Mandatory=$True, HelpMessage="Column Names to Select")]
        [String[]] $ColumnsToSelect
    )
    Begin{}
    Process{
        # Input CSV file contains both data and voice information. Filter out only relevant records and columns
        
        # Filter voice records
        $PSvoiceRecordsArr = Import-Csv $PathOfInputCSV | Where-Object {$_.$FilterColumnName -eq $FilterRowValue} 
        
        # Filter relevant columns
        $PSvoiceRowsColumnsArr = $PSvoiceRecordsArr | Select-Object -Property $ColumnsToSelect

        # Export this voiceRecordsCSV in results folder as csv file
        Export-PSObjectArrayToCSV -PSObjectArray $PSvoiceRowsColumnsArr -PathOfCSV  $PathOfOutputCSV   
    }
    End{}

    
}
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
Function Get-CallStatistics{
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