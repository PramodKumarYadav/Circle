# Test the working of individual functions and overall scripts here

# modules are scoped to the script, so we have to do this here. Cannot do it in say a function. 
$modules = Get-ChildItem -Path 'D:\FriendCircle\*.psm1' -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

# Give name of functions that you want to call here. example is given below.
$PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "C:\Users\Pramod Yadav\Desktop\books Treasure\Number.csv" -ColumnName "Dailled number"
Write-Host $PhoneNumbers

