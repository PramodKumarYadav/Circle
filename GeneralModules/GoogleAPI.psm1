# WIP: Yet to be Tested
Function Get-GAuthToken{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="As received when creating your google project")]
        [String] $RefreshToken,

        [Parameter(Mandatory=$True, HelpMessage="Client ID")]
        [String] $ClientID,

        [Parameter(Mandatory=$True, HelpMessage="CLIENT_SECRET")]
        [String] $ClientSecret
    )
    Begin{
        # Credits To: https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/ 
    }
    Process{
        # $RefreshToken = "$REFRESH_TOKEN"
        # $ClientID = "$CLIENT_ID"
        # $ClientSecret = "$CLIENT_SECRET"

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
        [Parameter(Mandatory=$False, HelpMessage="Access token for google contacts API")]
        [String] $accessToken = 'ya29.Il-7B7nPUWYf3XEO8dMN3Wp4s_rolbwlcZJyh19W6AJ1ekwxsLKJOsRepf7nOWkdBs2EexOSJKCbnNbUVx1m3foxHPAGNL2HlSVjCDivHUgZzCzTaT0R_JAYJaWw_ITwow'
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