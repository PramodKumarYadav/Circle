# :phone : Circle 

The idea behind the project is to see how our social health is. We have hundreds of contacts in our call list and yet there are often a handful of people we call.

This tool, will give you insight on who in your friends and family are most closest to you and thus by contrast, who are the people who were once very close to you but you never or seldom call.

Hope this helps in bringing friends and family closer to you.

# Scope
Since I have a lycamobile connection, the scope of the project (atleast at this moment) is to parse lyca mobile call logs and create insights from it.
However, I think once I am done with it, with minor modifications, you would be able to run it for your telephone statements as well with other service providers as well.

# Design
1. - [ ] Download account statement(s) from Lycamobile and copy them to TestData Directory (one or more allowed)
    * Note: The only option at their website is to get a report as PDF download.
    * Input: Lycamobile login details of user.
    * Output: PDF call logs file(s).
2. - [x] Convert PDF to TXT document.
    * Input: PDF call logs file
    * Output: Raw TXT file with calls logs and other irrelevant information.
3. - [x] Filter out the column header record and data records 
    * Input: Raw TXT file with calls logs and other irrelevant information.
    * Output: A filtered TXT file with only (Voice) call logs.
4. - [x] Convert TXT to CSV document.
    * Input: A filtered TXT file with only (Voice) call logs.
    * Output: A filtered CSV file with only (Voice) call logs.
5. - [x] Get the unique called phone numbers from this csv file.
    * Input: A filtered CSV file with only (Voice) call logs.
    * Output: An array of Unique phone numbers called by the user.
6. - [x] Get the frequency (count of calls per phone number) from this csv file.
    * Input: A filtered CSV file with only (Voice) call logs.
    * Output: An array of frequency (count of calls/per phone number).
7. - [x] Get the names from google contacts: [If user has signed up for this](./Secrets/Readme.md)
    * Input: Phone numbers array(point 5) and location of Secrets Json. 
    * Output: An array of Names corresponding to these called numbers.
8. - [x] Make a matrix with these three parameters  
    * Note: Goal is to create this matrix is such a way, that it can be used to create any output format as desired
    * Input: An array of Unique phone numbers; their corresponding frequency array; and their corresponding names
    * Output: A hastable collection array that can be converted to any format (as per the request of user)
9. - [x] Sort this matrix in the descending order of call frequency (since there is value in knowing who we called most to least)
    * Input: An unsorted hashtable array from previous step.
    * Output: A sorted hashtable array.
10. - [x] Display the result as json/csv/table (what you like)
    * Input: A sorted hastable collection array that can be converted to any format (as per the request of user)
    * Output: Based on the choice made by user in the main.ps1, it could be a JSON/CSV/Table output (All outputs or any combination, possible at any given time)

# Requirements
## If installing local
* Windows OS with Powershell 5 or more installed on it.
* Having lycamobile login credentials to be able to download pdf statements from their website.
## If runing on docker 
* Docker desktop installed.
* clone the project.
* Download and add the phone report(s) pdf(s) you want to analyse to TestData directory.
* [Add the client_secret file if you wish to have names with numbers using googles API.](./Secrets/Readme.md)
* PS D:\Circle> docker image build -t circle:v1 .
* PS D:\Circle> docker container run -it circle:v1
* PS /circle> ./main.ps1

# Execute 
If you want to run the main script with your lycamobile account statement, 
1. Download or clone this repository in one of your drives.
2. Go to lycamobile.nl. Login with your credentials and download your calls logs pdf. 
3. Put this call logs pdf file in TestData repository.
4. Run the main.ps1 script in the root folder of this project.
5. You should see the results in directory './TestResults/*'

# Feature List (to add in future)
* - [ ] Option to filter on dates
* - [x] Option to show names in final output 
    - (If user chooses to sync his contacts to google contacts from his smart phone and provide a secrets json file in Secrets directory. Steps shared here.)
    - [x] Full Instructions on how to do this.
* - [ ] Option to download data from lycamobile via script.
* - [x] Option to report on more than one pdf statements at the same time.
* - [x] Sort final stats as per CallFrequency (This will show who you call the most on top).

# Reference
* [Readme markdown-cheatsheet](https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md "Readme markdown-cheatsheet")
* [emoji-cheat-sheet](https://www.webfx.com/tools/emoji-cheat-sheet/ "emoji-cheat-sheet")
* [a cool website to refer for powershell tips and tricks](https://thinkpowershell.com/)
* [Use of $PSScriptRoot  to get script location](https://thinkpowershell.com/add-script-flexibility-relative-file-paths/)

# Approaches to parse PDF
1. First approach was to try and convert pdf to csv. I first tried an API option (as below). Worked Okay but due to limited option to use this free only for first 50 pages, I couldnt use this anymore as a long term solution. Thus rejected. Keeping here for reference, in case if a project pays to use this for a use case of pdf2csv conversion. 
* [powershell-pdftables-api](https://github.com/pdftables/powershell-pdftables-api )
* [To-get-your-API-key-from-PDFTables](https://pdftables.com/pdf-to-excel-api)
* [How-to-sign-external-scripts-to-be-able-to-run-on-your-system](https://devblogs.microsoft.com/scripting/hey-scripting-guy-how-can-i-sign-windows-powershell-scripts-with-an-enterprise-windows-pki-part-2-of-2/)
2. Finally found a stand alone solution to use itextsharp.dll. Using this we can do pdf to txt conversion. So I needed another step to do a txt to csv conversion. Worked okay with some tweaks.
* [Convert-PDF powershell module that uses itextsharp.dll](https://www.powershellgallery.com/packages/Convert-PDF/1.1 )
* [Reference on itextsharp](https://github.com/itext/itextsharp )
3. Tool used by lycamobile to create there pdfs.
* [Tool-used-by-lycamobile-to-pdf-convert-their-documents](https://tcpdf.org/) 
