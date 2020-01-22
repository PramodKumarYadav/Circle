# Test the working of individual functions and overall scripts here

# modules are scoped to the script, so we have to do this here. Cannot do it in say a function. 
$thisDir = $PSScriptRoot  # This will always give you the directory of this script (root in this case)
$rootDir = Split-Path -Path $thisDir
$modules = Get-ChildItem -Path "$rootDir\*.psm1" -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

# Give name of functions that you want to call here. example is given below.
Clear-Directory -Path "$rootDir\TestResults" -Exclude "Readme.md"
