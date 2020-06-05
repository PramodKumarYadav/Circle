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

            Describe "Get-Circle Test"{
                Context "when user forgets to provide input pdf file to analyse" {
                    It "exits the program, with a warning to provide input files"{
                        $false| should be $true
                    }
                }
            }

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

            # Initialise TestResults directory to store all results
            $TestResultsDir = "$RootDir\TestResults\$PDFName"
            Initialize-Directory -Path $TestResultsDir

            # Convert the PDF input file to a TXT file
            $RawTXTFile = "$TestResultsDir\RawTXTFile.txt"
            Convert-PDF2TXT -file "$PDFFile" > "$RawTXTFile"

            # Find out what kind of report it is (i.e. lycamobile or lebara)
            $reportType = Get-ReportType -Path "$RawTXTFile"

            # Proceed with the application settings as per the selected report
            if($reportType -eq 'Unknown'){
                break;
            }

            # Get application settings for report under test
            $appSettingsJson = Get-Content -Path "$RootDir\appsettings.json" | ConvertFrom-Json 
            $reportJson = $appSettingsJson.$reportType

            # Filter out the relevant data records from this RawFile
            $DataRecordsTXTFile = "$TestResultsDir\DataRecordsTXTFile.txt"
            Select-DataRecords -InputFile "$RawTXTFile" -OutputFile "$DataRecordsTXTFile" -RegEx $reportJson.FilterRecordsRegex

            # Convert these txt data records into parceable data records
            $ParceableTXTFile = "$TestResultsDir\ParceableTXTFile.txt"
            Convert-RawTXT2ParceableTXTFile -Report "$reportType" -InputFile "$DataRecordsTXTFile" -OutputFile "$ParceableTXTFile"

            # Convert this TXT file to a proper CSV file
            $ParsedCSVFile = "$TestResultsDir\ParsedCSVFile.csv"
            $Header = $reportJson.Header.split(",") # We need a header array from the string value.
            Import-Csv "$ParceableTXTFile" -delimiter $reportJson.Delimiter -Header $Header | Export-Csv "$ParsedCSVFile"

            # Get all Called phone numbers from the csv
            $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$ParsedCSVFile" -ColumnName $reportJson.NumberColumnName

            # Get the frequency of calls
            $CallFrequency = Get-CallFrequency -PathOfCSV "$ParsedCSVFile" -ColumnName $reportJson.NumberColumnName

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
