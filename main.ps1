# This is the entry point to run the Circle project. Run this to run the project. 

# Keep this main script in the root directory of the project (i.e. do not move its location)
$modules = Get-ChildItem -Path "$PSScriptRoot\*.psm1" -Recurse -Force
foreach($module in $modules){
    Write-Host "Importing module... $module"
    Import-Module $module -Force
}

# You only need to pass the root directory information. Rest all paths are used relative to root directory in scripts.
Get-Circle -RootDir "$PSScriptRoot" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose
# Get-CircleLebara -RootDir "$PSScriptRoot" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose