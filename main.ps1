# This is the entry point to run the Circle project. Run this to run the project. 
$currentDir = Get-Location  # Should give you your current directory where you downloaded this project
$modules = Get-ChildItem -Path "$currentDir\*.psm1" -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

# You can change the file path below to either run with your real data (say PersonalCallLogs.csv) or with dummy data (OriginalPDF2CSVConvertedFile.csv)
Get-Circle -PathOfInputCSVFile "$currentDir\TestData\OriginalPDF2CSVConvertedFile.csv" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose
