function Get-Circle{

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="The root directory of where ever user choose to download this project")]
        [String] $RootDir,

        [switch]$SaveAsJSON,

        [switch]$SaveAsCSV,

        [switch]$SaveAsTable
    )
    Begin{
        # Check if there is a input pdf file to analyse. If not, exit program. 
        $PDFFile = Get-ChildItem "$RootDir\TestData\*.pdf" 
        if (Test-Path -Path $PDFFile){
            $pdfName = Split-Path -Path "$PDFFile" -Leaf -Resolve
            Write-Host "Creating call log analysis for ... $pdfName"
        }else{
            Write-Host "No input file to analyse. Provide a pdf call log at location: $RootDir\TestData\*.pdf"
            Write-Host "Exiting program!"
            break;
        }
    }
    Process{
        # Define variable to store all TestResults
        $TestResultsDir = "$RootDir\TestResults"

        # Convert the PDF input file to a TXT file
        $RawTXTFile = "$TestResultsDir\RawTXTFile.txt"
        Convert-PDF2TXT -file "$PDFFile" > "$RawTXTFile"

        # Filter out the relevant records from this RawFile
        $FilteredTXTFile = "$TestResultsDir\FilteredTXTFile.txt"
        $RegExDataToFilter = '(VOICE).*'
        Select-DataRecords -InputFile "$RawTXTFile" -OutputFile "$FilteredTXTFile" -RegEx "$RegExDataToFilter"

        # Convert this TXT file to a proper CSV file
        $FilteredCSVFile = "$TestResultsDir\FilteredCSVFile.csv"
        $Header = 'Call Type','Customer number','Dialled number','Date','Time','CallDuration','Cost'
        Import-Csv "$FilteredTXTFile" -delimiter " " -Header $Header | Export-Csv "$FilteredCSVFile"

        # Get all Called phone numbers from the csv
        $PhoneColumnName = 'Dialled number' 
        $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$FilteredCSVFile " -ColumnName "$PhoneColumnName"

        # Get the frequency of calls
        $CallFrequency = Get-CallFrequency -PathOfCSV "$FilteredCSVFile " -ColumnName "$PhoneColumnName"

        # Get the call statistics matrix based on phone numbers and their frequency
        $PSOrderedDictionaryArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency

        # Create output in the requested format(s) by user
        Save-ResultInExpectedFormat -PSOrderedDictionaryArray $PSOrderedDictionaryArray -SaveAsJSON:$SaveAsJSON -SaveAsCSV:$SaveAsCSV -SaveAsTable:$SaveAsTable -PathOfOutputDir $TestResultsDir
        
        # Also show the result as a table (for a quick look in powershell console)
        $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize 
    }
    End{}
}
