# Test the working of individual functions and overall script
$modules = Get-ChildItem -Path 'D:\FriendCircle\*.psm1' -Recurse -Force
foreach($module in $modules){
    Import-Module $module -Force
}

$PathCSV = 'D:\FriendCircle\TestData\Number.csv'
$PhoneNumber = 'Dailled number'
$PhoneNumbers = Get-UniquePhoneNumbers -PathOfCSV "$PathCSV " -ColumnName "$PhoneNumber"
Write-Host $PhoneNumbers

$CallFrequency = Get-CallFrequency -PathOfCSV "$PathCSV " -ColumnName "$PhoneNumber"
Write-Host $CallFrequency

$PSObjectArray  = Set-CallStatistics -PhoneNumbers $PhoneNumbers -CallFrequency $CallFrequency
Convert-PSObjectArrayToJSON -PSObjectArray $PSObjectArray



# $obj2 = New-Object -TypeName PSObject 

# $obj2 = Get-UniqueValuesFromAColumn -PathOfCSV "$PathCSV " -ColumnName "$PhoneNumber"
# Write-Host $obj2.count
# Write-Host $obj2.PhoneNumber[0]
# Write-Host $obj2.PhoneNumber[1]

# $json = $obj2 | ConvertTo-Json
# $json > 'D:/testJson.txt'

$somearr = @('adf','dfd','dsfsdf')
$json2 = $somearr | ConvertTo-Json
$json2 > 'D:/testJson2.txt'

Function Get-UniqueCalledNumbers{
    [CmdletBinding()]
    Param(
        #Want to support multiple computers
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV,

        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $ColumnName
    )
    Begin{}
    Process{
        foreach($Computer in $ComputerName){
            $os=Get-Wmiobject -ComputerName $Computer -Class Win32_OperatingSystem
            $Disk=Get-WmiObject -ComputerName $Computer -class Win32_LogicalDisk -filter "DeviceID='c:'"
            
            $Prop=[ordered]@{ #With or without [ordered]
                'ComputerName'=$computer;
                'OS Name'=$os.caption;
                'OS Build'=$os.buildnumber;
                'FreeSpace'=$Disk.freespace / 1gb -as [int]
            }
        $Obj = New-Object -TypeName PSObject -Property $Prop 
        Write-Output $Obj

        } 
    }
    End{}
}

Function Get-UniqueValuesFromAColumn2{
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory=$True, HelpMessage="Path of CSV file that contains call logs")]
        [String] $PathOfCSV,

        [Parameter(Mandatory=$True, HelpMessage="The column name based on which you want to fetch unique values")]
        [String] $ColumnName
    )
    Begin{}
    Process{
        $csv = Import-Csv $PathOfCSV | Group-Object {$_.$ColumnName}
        $names = $csv.Name
        return $names       
    }
    End{}
}
