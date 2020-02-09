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
            Write-Host "client_secret file not available @:$PathSecretsDir .Can not provide names."
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
    Begin{}
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