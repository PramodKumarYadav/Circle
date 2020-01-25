# Tested Okay with valid parameters
Function Get-GAuthToken{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Taken manually by giving valid client Id and ClientSecret in: https://developers.google.com/oauthplayground/")]
        [String] $RefreshToken,

        [Parameter(Mandatory=$True, HelpMessage="Client ID received by manually creating OAuth 2.0 Client IDs")]
        [String] $ClientID,

        [Parameter(Mandatory=$True, HelpMessage="Client secret received by manually creating OAuth 2.0 Client IDs")]
        [String] $ClientSecret
    )
    Begin{
        # Credits To: https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/ 
    }
    Process{
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
                    $item = [pscustomobject][Ordered]@{
                                                Name = $Record.title.'$t'
                                                Number = $Number.'$t'
                                            }
                    $Contacts += $item
                }
            }
        }
        return $Contacts
    }
    End{}
}

# Need a function to set - import contacts to keep data uptodate in cloud

# Need a function to create authentication token on run time (since tokens expire)