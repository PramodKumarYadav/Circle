function Get-Circle{

    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV
    )
    Begin{}
    Process{
        # CSV file contains both data and voice information. Filter out only relevant records and columns
        $PathOfVoiceRecords = "./TestResults/VoiceRecords.csv "
        Get-VoiceRecords -PathOfInputCSV "$PathOfCSV" -PathOfOutputCSV "$PathOfVoiceRecords" -FilterColumnName 'Call Type' -FilterRowValue 'VOICE' -ColumnsToSelect 'Dailled number','Date', 'CallDuration'

        # Get all Called phone numbers from the csv
        $PhoneColumnName = 'Dailled number' # Well this incorrect spelling is what you get when you download data from lycamobiles website
        $PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$PathOfVoiceRecords " -ColumnName "$PhoneColumnName"
        Write-Host $PhoneNumbers

        # Get the frequency of calls
        $CallFrequency = Get-CallFrequency -PathOfCSV "$PathOfVoiceRecords " -ColumnName "$PhoneColumnName"
        Write-Host $CallFrequency

        # Get the call statistics matrix based on phone numbers and their frequency
        $PSObjectArray  = Get-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency
        Convert-PSObjectArrayToJSON -PSObjectArray $PSObjectArray      
    }
    End{}
}
