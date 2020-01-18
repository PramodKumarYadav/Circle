# Test the working of individual functions and overall script
$currentDir = Get-Location  # Should give you your current directory where you downloaded this project
$modules = Get-ChildItem -Path "$currentDir\*.psm1" -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

Get-Circle -PathOfCSV "$currentDir\TestData\Number.csv"
