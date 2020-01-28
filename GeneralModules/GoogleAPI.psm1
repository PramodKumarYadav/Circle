# Tested Okay with valid parameters
Function Get-GAuthToken{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of your secrets json file where all your secrets are stored")]
        [String] $PathDirectorySecrets
    )
    Begin{
        # Credits To: https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/ 
    }
    Process{
        # Get client_id and client_secret from your Secrets\client_secret*.json file
        $ClientSecretFile = Get-ChildItem "$PathDirectorySecrets\client_secret*.json" -Recurse
        $jsonObj = Get-Content $ClientSecretFile | ConvertFrom-Json

        # Get Client ID, Secret and refresh token from this file
        $ClientID = $jsonObj.web.client_id
        $ClientSecret = $jsonObj.web.client_secret
        # For now, get refresh token from https://developers.google.com/oauthplayground/ and add it manually in the secrets file (to avoid exposing it here)
        # Process to use oAuth tokens based on your client id and secret is here: https://monteledwards.com/2017/03/05/powershell-oauth-downloadinguploading-to-google-drive-via-drive-api/ 
        $RefreshToken = $jsonObj.web.refresh_token 

        # Build URI and get access token
        $grantType = "refresh_token"
        $requestUri = "https://accounts.google.com/o/oauth2/token" 
        $GAuthBody = "refresh_token=$RefreshToken&client_id=$ClientID&client_secret=$ClientSecret&grant_type=$grantType"
        $GAuthResponse = Invoke-RestMethod -Method Post -Uri $requestUri -ContentType "application/x-www-form-urlencoded" -Body $GAuthBody     
        return $GAuthResponse.access_token
    }
    End{}
}

# Tested OKay
Function Get-NameAndNumberFromGoogleContacts{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Access token for google contacts API")]
        [String] $accessToken
    )
    Begin{
        # Credits To: https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/ 
    }
    Process{
        # Define headers including access Token
        $headers = @{"Authorization" = "Bearer $accessToken"         
                    "Content-type" = "application/json"}

        # Manually [In oAuthplayground 1. Select People API -Contact; Exchange authrorisatin code for tokens; List possible options: Contacts V3-> List contacts ]
        # Above actions, gives you this url: https://www.google.com/m8/feeds/contacts/default/full/ (Added options are to get all pages data at once in JSON frmt)
        $Response = Invoke-RestMethod -Uri "https://www.google.com/m8/feeds/contacts/default/full?start-index=1&max-results=999999&alt=json" -Method Get -Headers $headers        
        $Contacts = @()
        Foreach ($Record in $Response.feed.entry) {
            If ($Record.'gd$phoneNumber') {
                Foreach ($Number in $Record.'gd$phoneNumber') {
                    $PSitem = [psobject][ordered]@{
                                'Name' = $Record.title.'$t'
                                'Number' = $Number.'$t'
                            }

                    $Contacts += $PSitem
                }
            }
        }
        return $Contacts
    }
    End{}
}

# Normalise contacts as per the format of numbers found in lycamobile (for matching)
Function Get-NormalizedContactNumbers{
    [CmdletBinding()]
    Param(
        [parameter(Mandatory,ValueFromPipeline)]
        [object[]]$Contacts
    )
    Begin{}
    Process{
        # Normalise contact numbers for lookup with actual numbers from lycamobile report
        foreach($Contact in $Contacts){
            # Normalise contact numbers as per the format in lycamobile (so remove '-', '+', '(', ')', and all white spaces from the numbers)
            $Contact.Number = $Contact.Number -replace '-','' -replace '\+','' -replace '\(','' -replace '\)','' -replace '\s+', ''

            # We intend to match the last 9 digits only (since for ex: for NL, a number in lycamobile report 31612345678 could be stored in google as 0612345678)
            $matchDigitsCount = 9
            $lengthNr = $Contact.Number.Length
            if ($lengthNr -gt $matchDigitsCount){
                $startIndex = $lengthNr - $matchDigitsCount
                $Contact.Number = $Contact.Number.Substring($startIndex, $matchDigitsCount)
            }
        }
        return $Contacts
    }
    End{}
}

# Get Contact numbers for dialled numbers
Function Get-ContactNamesForDialledNumbers{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Array of unique dialled numbers")]
        [String[]] $PhoneNumbers,

        [Parameter(Mandatory=$True, HelpMessage="Array of unique dialled numbers")]
        [object[]]$NormalizedContacts
    )
    Begin{}
    Process{
        # For each phone number get the corresponding lookup name from the NormalizedContacts Dictionary
        $Names = [String[]]@()
        foreach($PhoneNumber in $PhoneNumbers){
            # Check the length of PhoneNumber. If less than 9, start index remains 0. Otherwise, we skip first few digits to only get last 9 digits.
            $lengthNr = $PhoneNumber.Length
            $startIndex = 0
            $matchDigitsCount = 9
            if ($lengthNr -gt $matchDigitsCount){
                $startIndex = $lengthNr - $matchDigitsCount
            }
            
            # We intend to match the last 9 digits only (since for ex: for NL, a number in lycamobile report 31612345678 could be stored in google as 0612345678)            
            $index = [array]::indexof($NormalizedContacts.Number, $PhoneNumber.Substring($startIndex, $matchDigitsCount) )
            Write-Verbose "Matching number found in GoogleContacts @: $index"
            if($index -eq -1){
                $Names += ' '
            }else{  
                $Names += $NormalizedContacts.Name[$index]
            }
        }      
        return $Names
    }
    End{}
}