# This is the entry point to run the Circle project. Run this to run the project. 

# Put this script in the root directory of the project
$rootDir = $PSScriptRoot  # This will always give you the directory of this script (root in this case)
$modules = Get-ChildItem -Path "$rootDir\*.psm1" -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

# You only need to pass the root directory information. Rest all paths are used relative to root directory.
Get-Circle -RootDir "$rootDir" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose
