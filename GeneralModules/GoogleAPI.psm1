# Tested OKay
Function Select-DataRecords{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$False, HelpMessage="Access token for google contacts API")]
        [String] $accessToken = 'ya29.Il-7B5msfsn1IYWY4qMxvk-AcPdP7X4ce9NM0H5zLzsHvcNCEkT0FDAlI1JkI5ktM93XRjbx0ej0r7R75xJwjbLK9ojfzus3K3DwS-XUe26SfLp0uwid8FHaeNwePEb_Xw'
    )
    Begin{}
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