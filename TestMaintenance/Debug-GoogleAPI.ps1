# Test the working of individual functions and overall scripts here

# modules are scoped to the script, so we cannot refactor below importing module code to say a function. 
$rootDir = Split-Path -Path $PSScriptRoot  # Parent of current directory
$modules = Get-ChildItem -Path "$rootDir\*.psm1" -Recurse -Force
foreach($module in $modules){
    Write-Host "Importing module... $module"
    Import-Module $module -Force
}

# Give name of functions that you want to call here. example is given below.
$accessToken = Get-GAuthToken -PathDirectorySecrets "$rootDir\Secrets" 

$Contacts = Get-NameAndNumberFromGoogleContacts -accessToken $accessToken
$Contacts | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize 