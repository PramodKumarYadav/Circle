# To generate authentication tokens manually, use this website
* [To create your google project](https://console.cloud.google.com/cloud-resource-manager)
* [To create your oAuth keys: Client ID and Client Secret](https://developers.google.com/identity/protocols/OpenIDConnect#getcredentials)
* [To get Refresh tokens (Indefinite duration)](https://monteledwards.com/2017/03/05/powershell-oauth-downloadinguploading-to-google-drive-via-drive-api/)
    * [Set a redirect URI (needed for getting indefinite refresh tokens)](https://developers.google.com/identity/protocols/OpenIDConnect#setredirecturi) 

# Google Developers
* [Google oauthplayground](https://developers.google.com/oauthplayground/ )
    * [A how to video on working with Google oauthplayground](https://www.youtube.com/watch?v=nRF_HdrYeGE ) 
* [People API Get URLs for contact details](https://developers.google.com/people/api/rest/v1/people/get) 

# Powershell scripts to work with oAuth tokens
* [Install-Module -Name GoogleOAuth2](https://www.powershellgallery.com/packages/GoogleOAuth2/1.0.1.0)

# Reference
* [Solution to get Names-Numbers](https://www.reddit.com/r/PowerShell/comments/7ax36a/powershell_and_google_contacts_api/)

# Summary: 
## Steps to create a Google project and ClientID and ClientSecret
1. Create a Google project.
2. Enable Contacts API.
3. Create oAuth credentials i.e. Client ID and Client Secret keys
4. Save the keys as a JSON file in your Secrets directory (this folder).
    - You dont have to rename the long file name (but if you want, you can. Just dont change the file extension. Keep it as .json).
    - All the files in Secrets directory (Except readme.md) are ignored. So you dont have to worry about accidentally publishing it on say github.
    - Thus your secrets are safe on your computer (as long as your computer is safe from viruses i.e.)
    - Do not add any other file here (atleast not a json file).

# Detailed: 
## Step by step instructions.
### 1. [Create a google project](https://console.cloud.google.com/cloud-resource-manager) ###

    <img src= "../Images/CreateProject.png">
    <img src= "../Images/ProjectName.png">
    <img src= "../Images/ProjectCreated.png" >
### 2. Go to Navigation Menu
    <img src= "../Images/NavigationMenu.png" >
### 3. Enable Contacts API  
    <img src= "../Images/APIsAndServices-Dashboard.png">
    <img src= "../Images/EnableAPIsAndServices.png">
    <img src= "../Images/ContactsAPI.png">
    <img src= "../Images/EnableContactsAPI.png">
### 4. Create Credentials (oAuth keys:  Client ID and Client Secret keys)
    * Either from the ContactsAPI page as shown below.
    <img src= "../Images/CreateCredentials.png">
    <img src= "../Images/Credentials-oAuthClientID.png">
    <img src= "../Images/SetProductNameOnConsentScreen.png">
    <img src= "../Images/oAuthConsentScreen.png">
    <img src= "../Images/GiveApplicationName.png">
    <img src= "../Images/GoBackToCredentials.png">
    <img src= "../Images/TryCreateCredentialsAgain.png">
    <img src= "../Images/oAuthClientID.png">
    <img src= "../Images/CreateoAuthClientID.png">
    <img src= "../Images/ClientIDAndClientSecretCreated.png">
    
    #### You can also view this anytime from the credentials page (or even set up from there as shown below)
    <img src= "../Images/CredentialsMenu.png">
    <img src= "../Images/ViewCredentials.png">
    <img src= "../Images/ViewClientIDAndClientSecret.png">
### 5. Save the keys as a JSON file in your Secrets directory (this folder).

    <img src= "../Images/DownloadJSON.png">
    <img src= "../Images/DownloadedFile.png">
    <img src= "../Images/CopyFileFromDownloads.png">
    <img src= "../Images/MoveFileToSecrets.png">

    #### Or from the 
3. [Create oAuth keys:  Client ID and Client Secret keys](https://developers.google.com/identity/protocols/OpenIDConnect#getcredentials)

    

# Reference
* [How to insert images in github readme.md files](https://youtu.be/hHbWF1Bvgf4)
