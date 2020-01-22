# Tested OKay
Function Select-DataRecords{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of Input file that needs to be filtered")]
        [String] $InputFile,

        [Parameter(Mandatory=$True, HelpMessage="Path of filtered Output file")]
        [String] $OutputFile,

        [Parameter(Mandatory=$True, HelpMessage="The regex based on which you want to filter out mathching records")]
        [String] $RegEx
    )
    Begin{}
    Process{
        # Create a new outputfile to store the filtered information
        New-Item -Path "$OutputFile" -ItemType "file" -Force > $null # To get silent output.

        # Get matching data records and add to the output file
        foreach($line in Get-Content $InputFile) {
            if($line -match $RegEx){
                Add-Content -Path "$OutputFile" -Value "$line" 
            }
        }
    }
    End{}
}

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

Function Install-ModuleIfNotInstalledAlready{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [string[]]$ModuleName
    )
    Begin{}
    Process{      
        foreach($module in $ModuleName){
            # Install module if not installed already
            if (Get-Module -ListAvailable -Name "$module") {
                Write-Host "$module module exists"
            }
            else {
                Write-Host "$module module does not exist. Installing now..."
                Install-Module -Name "$module"
            }
        }
    }
    End{}
}

function Initialize-Directory {
	param(
            [String]$Path
        )
    
	if (Test-Path $Path){
        Write-Information "$Path Exist. Deleting directory now!"
        # Due to a known bug in remove-item, we have to do it this way.
        Get-ChildItem -LiteralPath $Path -recurse | Remove-Item -Recurse -Force
        New-Item -Path $Path -ItemType "directory" -Force > $null # To get silent output.

	}else {
		Write-Information "$Path doesn't exist. Creating directory now!"
		New-Item -Path $Path -ItemType "directory" -Force > $null # To get silent output.
	}
}

function Clear-Directory {
	param(
            [String]$Path,
            [String]$Exclude
        )
    
	if (Test-Path $Path){
        Write-Information "$Path Exist. Deleting directory now!"
        # Due to a known bug in remove-item, we have to do it this way.
        Get-ChildItem -LiteralPath $Path -recurse -Exclude "$Exclude"| Remove-Item -Recurse -Force

	}else {
		Write-Information "$Path doesn't exist!"
	}
}

