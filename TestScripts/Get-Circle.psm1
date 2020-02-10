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
        # Check if there is/are input pdf file(s) to analyse. If not, exit program. 
        $PDFFiles = Get-ChildItem "$RootDir\TestData\*.pdf" 
        if ($PDFFiles){
            Write-Host "PDF files exist in TestData directory."
            Write-Host "Creating CallStatistics for each of them now..."
        }else{
            Write-Host "No input file to analyse. Provide a pdf call log at location: $RootDir\TestData\*.pdf"
            Write-Host "Exiting program!"
            break;
        }

        # Intialize TestResults directory for this Run (except readme file)
        Clear-Directory -Path "$RootDir\TestResults" -Exclude "Readme.md"
    }
    Process{
        # Create CallStatistics for each of these PDF files 
        foreach($PDFFile in $PDFFiles){
            #Get pdfFile name and create a name without spaces
            $PDFName = Split-Path -Path "$PDFFile" -LeafBase -Resolve
            $PDFName = $PDFName -replace '\s', '_'
            Write-Host "Creating call log analysis for ... $PDFName"

            # Define variable to store all TestResults
            $TestResultsDir = "$RootDir\TestResults\$PDFName"
            Initialize-Directory -Path $TestResultsDir

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
            $NumberColumnName = 'Dialled number' 
            $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$FilteredCSVFile" -ColumnName "$NumberColumnName"

            # Get the frequency of calls
            $CallFrequency = Get-CallFrequency -PathOfCSV "$FilteredCSVFile" -ColumnName "$NumberColumnName"

            # Get the names of people called (If user has set up this option to provide a Secrets json with Client ID and Client Secret)
            $Names = Get-ContactNames -PathSecretsDir "$RootDir\Secrets" -PhoneNumbers $PhoneNumbers
            
            # Get the call statistics matrix based on phone numbers and their frequency
            $PSOrderedDictionaryArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency -Names  $Names

            # Sort this dictionary in descending order of call Frequency (Since there is value in knowing who you call the most)
            $SortedDictionary = $PSOrderedDictionaryArray.GetEnumerator() | Sort-Object -Property @{Expression={[int]$_.CallFrequency}; Descending=$true}

            # Create output in the requested format(s) by user
            Save-ResultInExpectedFormat -PSOrderedDictionaryArray $SortedDictionary -SaveAsJSON:$SaveAsJSON -SaveAsCSV:$SaveAsCSV -SaveAsTable:$SaveAsTable -PathOfOutputDir $TestResultsDir

            # Also show the result as a table (for a quick look in powershell console)
            $SortedDictionary | ForEach-Object {[PSCustomObject]$_} | Format-Table -AutoSize 
        }
    }
    End{}
}
