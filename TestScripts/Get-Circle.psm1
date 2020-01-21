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

    }
    Process{

        # Check if there is a input pdf file to analyse. If not, return. 
        $inputPDFFile = Get-ChildItem "$RootDir\TestData\*.pdf" 
        if (Test-Path -Path $inputPDFFile){
            $pdfName = Split-Path -Path "$inputPDFFile" -Leaf -Resolve
            Write-Host "Creating call log analysis for ... $pdfName"
        }else{
            Write-Host "No input file to analyse. Provide a pdf call log at location: $RootDir\TestData\*.pdf"
            return
        }

        # Define variable to store all TestResults
        $TestResultsDir = "$RootDir\TestResults"

        # Convert the PDF input file to a TXT file
        $PDF2TXTFile = "$TestResultsDir\01_PDF2TXT.txt"
        Convert-PDF2TXT -file "$inputPDFFile" > "$PDF2TXTFile"

        # Convert this TXT file to a proper CSV file
        $TXT2CSVFile = "$TestResultsDir\02_TXT2CSV.csv"
        $Header = 'Call Type','Customer number','Dialled number','Date','Time','CallDuration','Cost'
        Import-Csv "$PDF2TXTFile" -delimiter " " -Header $Header | Export-Csv "$TXT2CSVFile"

        # Extract Header and Data records from input csv file (this also contains some non relevant information from logs perspective)
        $HeaderString = $Header -join ","
        $WellFormedCSV = "$TestResultsDir\03_WellFormedCSV.csv"
        Get-CallLogsDataAsCSV   -PathOfInputCSVFile "$TXT2CSVFile" `
                                -PathOfOutputCSVFile  "$WellFormedCSV" `
                                -Header $HeaderString `
                                -RecordsRegEx '("DATA"|"VOICE"),.*'

        # CSV file contains both data and voice information. Filter out only relevant records and columns
        $VoiceRecordsCSV = "$TestResultsDir\04_VoiceRecordsCSV.csv "
        Get-VoiceRecords    -PathOfInputCSV "$WellFormedCSV" `
                            -PathOfOutputCSV "$VoiceRecordsCSV" `
                            -FilterColumnName 'Call Type' `
                            -FilterRowValue 'VOICE' `
                            -ColumnsToSelect 'Dialled number','Date', 'CallDuration'

        # Get all Called phone numbers from the csv
        $PhoneColumnName = 'Dialled number' 
        $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$VoiceRecordsCSV " -ColumnName "$PhoneColumnName"

        # Get the frequency of calls
        $CallFrequency = Get-CallFrequency -PathOfCSV "$VoiceRecordsCSV " -ColumnName "$PhoneColumnName"

        # Get the call statistics matrix based on phone numbers and their frequency
        $PSOrderedDictionaryArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency

        # Create output in the requested format(s) by user
        Save-ResultInExpectedFormat -PSOrderedDictionaryArray $PSOrderedDictionaryArray -SaveAsJSON:$SaveAsJSON -SaveAsCSV:$SaveAsCSV -SaveAsTable:$SaveAsTable -PathOfOutputDir $TestResultsDir
        
        # Also show the result as a table (for a quick look in powershell console)
        $PSOrderedDictionaryArray | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize 
    }
    End{}
}
