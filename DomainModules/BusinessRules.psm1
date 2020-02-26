# Get report type
function Get-ReportType {
	param(
            [String]$Path 
        )
    
    # list of all reports that the framework can handle
    $reportTypes = @('Lycamobile','Lebara')
    foreach($report in $reportTypes){
        $result = Get-Content -Path $Path -Raw | Select-String $report

        if($result){
            Write-Host "Input PDF is a $report report. Processing now..."
            return $report
        }
    }

    # If neither of above, return, not found and break
    Write-Host "Input PDF is not a $reportTypes report. Cannot process!"
    return 'Unknown'
}
# Convert Raw Txt to a parseable csv file and return the path
function Convert-RawTXT2ParceableTXTFile {
	param(
            [String] $Report,
            [String] $TestResultsDir
        )

    # Data records file is the input 
    $DataRecordsTXTFile = "$TestResultsDir\DataRecordsTXTFile.txt"
    
    # Lycamobile, files are already parceable, So use Data records file as parceable file.
    if($Report -eq 'Lycamobile'){
        $ParceableTXTFile = $DataRecordsTXTFile
    }

    # Lebara file needs to be fixed before it can be parsed.
    # Convert this TXT file to a comma seperated TXT file (numbers are of varying length and contain spaces so cannot directly parse)
    if($Report -eq 'Lebara'){
        $ParceableTXTFile = "$TestResultsDir\ParceableTXTFile.txt"
        
        # In lebara mobile report, there are first few fixed columns, "with a varying length phone nr", then a cost value which starts with € sign.
        #  22/01/2020 16:45 00:00:24 31600 123 456 €0.00
        # 21/01/2020 22:28 00:00:26 911234 567 890 €0.00
        $newcontent = Convert-FixedLengthLebaraRecordsToCSV -Path "$DataRecordsTXTFile" -Positions @(11, 17, 26) -AddDelimiter ',' 
        $newcontent > $ParceableTXTFile
    }

    return $ParceableTXTFile
}

# Parsing lebara records
function Convert-FixedLengthLebaraRecordsToCSV {
	param(
            [String]$Path,
            [Int[]]$Positions,
            [String]$AddDelimiter
        )
    
    # a variable to store updated content
    $newContent = @()

    # get text content
    $content = Get-Content -Path $Path
    foreach($line in $content){
        
        # Get position of euro symbol (most times it will be 5th from last (€0.00) but if there is cost involved (ex: €12.34), this can change.)
        $euroPosition = $line.IndexOf("€")

        # Add the last delimiter position based on the length of line
        $newPositions = $Positions + $euroPosition

        # define column breaks in descending order 
        # Reason: so that it doesnt impact position of other delimiters - when inserting them in line. which would change if done in asc order.
        $newPositions = $newPositions | Sort-Object -Descending

        # Insert delimiter at each position starting from the end 
        foreach($position in $newPositions){
            $line = $line.Insert($position, $AddDelimiter)  
        }

        # Add this updated line to new content
        $newContent += $line
    } 

    # Trim all spaces from numbers before returning
    $newContent = $newContent.Replace(' ','')

    return $newContent
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

# Get Contact Names for each number called
Function Get-ContactNames{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Array of unique dialled numbers")]
        [String] $PathSecretsDir,

        [Parameter(Mandatory=$True, HelpMessage="Array of unique dialled numbers")]
        [String[]] $PhoneNumbers
    )
    Begin{
        
    }
    Process{
        
        $ClientSecretFile = Get-ChildItem "$PathSecretsDir\client_secret*.json" -Recurse
        $names = @() # Initialize this array so that if user has not chosen for this option, the Get-CallStatistics function can still handle it with this empty declaration
        if($ClientSecretFile){
            Write-Host "client_secret file available @:$PathSecretsDir .Can provide names."
        }else{
            Write-Host "client_secret file not available @:$PathSecretsDir"
            Write-Host "Can not provide names. If you want to have names, do setup as shown in readme.md file @Secrets dir"
            return $names
        }
        
        # Get Access Token
        $accessToken = Get-GAuthToken -PathDirectorySecrets "$PathSecretsDir"  

        # Get Contacts PSItem array (Name- Number) combination
        $contacts = Get-NameAndNumberFromGoogleContacts -accessToken $accessToken

        # Normalise contact numbers as per the format in lycamobile (so remove spaces, '-' and '+' from the numbers)
        $normalizedContacts = Get-NormalizedContactNumbers -Contacts $contacts

        # Get contact names for dialled numbers
        $names = Get-ContactNamesForDialledNumbers -PhoneNumbers $PhoneNumbers -NormalizedContacts $normalizedContacts       
        return $names
    }
    End{}
}

# Tested OKay
Function Get-CallStatistics{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False, HelpMessage="Contact Names array (optional")]
        [object[]] $Names, # Default is empty array.If not provided.

        [Parameter(Mandatory=$True, HelpMessage="Phone Numbers array")]
        [String[]] $PhoneNumbers,

        [Parameter(Mandatory=$True, HelpMessage="Call Frequency array")]
        [String[]] $CallFrequency   
    )
    Begin{
        if($null -eq $Names){
            $Names = @()
        }
    }
    Process{
        $PSOrderedDictionaryArray = @()
        for($i = 0; $i -lt $PhoneNumbers.Count; $i++){
            $PSitem = [psobject][ordered]@{
                        'Name' = $Names[$i];
                        'PhoneNumber' = $PhoneNumbers[$i];
                        'CallFrequency' = $CallFrequency[$i]
                        }
            $PSOrderedDictionaryArray += $PSitem
        }
        
        return $PSOrderedDictionaryArray 
    }
    End{}
}