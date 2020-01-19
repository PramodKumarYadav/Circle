function Get-Circle{

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfInputCSVFile,

        [switch]$SaveAsJSON,

        [switch]$SaveAsCSV,

        [switch]$SaveAsTable
    )
    Begin{}
    Process{

        $currentDir = Get-Location
        $PathOfOutputDir = "$currentDir/TestResults"

        # Extract Header and Data records from input csv file (this also contains some non relevant information from logs perspective)
        $PathOfCSVDataFile = "$PathOfOutputDir/FullDataRecords.csv"
        Get-CallLogsDataAsCSV   -PathOfInputCSVFile "$PathOfInputCSVFile" `
                                -PathOfOutputCSVFile  "$PathOfCSVDataFile" `
                                -HeaderRegExPattern @("Call Type,Customer number") `
                                -RecordsRegExPattern @("(DATA|VOICE),.*")

        # CSV file contains both data and voice information. Filter out only relevant records and columns
        $PathOfVoiceRecords = "$PathOfOutputDir/VoiceRecords.csv "
        Get-VoiceRecords    -PathOfInputCSV "$PathOfCSVDataFile" `
                            -PathOfOutputCSV "$PathOfVoiceRecords" `
                            -FilterColumnName 'Call Type' `
                            -FilterRowValue 'VOICE' `
                            -ColumnsToSelect 'Dailled number','Date', 'CallDuration'

        # Get all Called phone numbers from the csv
        $PhoneColumnName = 'Dailled number' # Well this incorrect spelling is what you get when you download data from lycamobiles website
        $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$PathOfVoiceRecords " -ColumnName "$PhoneColumnName"
        Write-Host $PhoneNumbers

        # Get the frequency of calls
        $CallFrequency = Get-CallFrequency -PathOfCSV "$PathOfVoiceRecords " -ColumnName "$PhoneColumnName"
        Write-Host $CallFrequency

        # Get the call statistics matrix based on phone numbers and their frequency
        $PSOrderedDictionaryArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency

        # Create output in the requested format(s) by user
        Save-ResultInExpectedFormat -PSOrderedDictionaryArray $PSOrderedDictionaryArray -SaveAsJSON:$SaveAsJSON -SaveAsCSV:$SaveAsCSV -SaveAsTable:$SaveAsTable -PathOfOutputDir $PathOfOutputDir
    }
    End{}
}
