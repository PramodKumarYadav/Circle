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
        $inputPDFFile = Get-ChildItem "$RootDir\TestData\*.pdf" 
        if (Test-Path -Path $inputPDFFile){
            $pdfName = Split-Path -Path "$inputPDFFile" -Leaf -Resolve
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
        $PDF2RawTXTFile = "$TestResultsDir\PDF2RawTXT.txt"
        Convert-PDF2TXT -file "$inputPDFFile" > "$PDF2RawTXTFile"

        # Filter out the relevant records from this RawFile
        $RawTXT2FilteredRecords = "$TestResultsDir\RawTXT2FilteredRecords.txt"
        $RegExDataToFilter = '(VOICE).*'
        Select-DataRecords -InputFile "$PDF2RawTXTFile" -OutputFile "$RawTXT2FilteredRecords" -RegEx "$RegExDataToFilter"

        # Convert this TXT file to a proper CSV file
        $RecordsTXT2CSV = "$TestResultsDir\Records2CSV.csv"
        $Header = 'Call Type','Customer number','Dialled number','Date','Time','CallDuration','Cost'
        Import-Csv "$RawTXT2FilteredRecords" -delimiter " " -Header $Header | Export-Csv "$RecordsTXT2CSV"

        # Get all Called phone numbers from the csv
        $PhoneColumnName = 'Dialled number' 
        $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$RecordsTXT2CSV " -ColumnName "$PhoneColumnName"

        # Get the frequency of calls
        $CallFrequency = Get-CallFrequency -PathOfCSV "$RecordsTXT2CSV " -ColumnName "$PhoneColumnName"

        # Get the call statistics matrix based on phone numbers and their frequency
        $PSOrderedDictionaryArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency

        # Create output in the requested format(s) by user
        Save-ResultInExpectedFormat -PSOrderedDictionaryArray $PSOrderedDictionaryArray -SaveAsJSON:$SaveAsJSON -SaveAsCSV:$SaveAsCSV -SaveAsTable:$SaveAsTable -PathOfOutputDir $TestResultsDir
        
        # Also show the result as a table (for a quick look in powershell console)
        $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize 
    }
    End{}
}
