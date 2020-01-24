# Tested OKay
Function Get-NameAndNumberFromGoogleContacts{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False, HelpMessage="Access token for google contacts API")]
        [String] $accessToken = ''
    )
    Begin{
        # Credits To: https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/ 
    }
    Process{
        # Define headers including access Token
        $headers = @{"Authorization" = "Bearer $accessToken"         
                    "Content-type" = "application/json"}

        # Get response from contacts
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