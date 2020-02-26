# ☎ : Circle 

The idea behind the project is to see how our social health is. We have hundreds of contacts in our call list and yet there are often a handful of people we call. This tool, will give you insight on who in your friends and family are most closest to you and thus by contrast, who are the people who were once very close to you but you never or seldom call.

It does this by parsing the pdf phone call record from your service provider and creating insights on who you called and how often (with their names & numbers).

Hope this helps in bringing friends and family closer to you.

# Scope
    - Lycamobile reports (Nederlands)
    - Lebara reports (Nederlands)

# Input
1. Type: PDF reports
2. Download account statement(s) from Lycamobile (or Lebara) and copy them to TestData Directory
    * One or more pdfs are allowed in the TestData directory at the same time. 
    * Both Lebara and Lyca pdf reports are allowed in the TestData directory at the same time.
    * You can choose to name these reports as you like (or leave defaults). The tool 'looks' into the reports and finds out what kind of report it is dealing with and acts accordingly.
    * Note: The only known option at both lycamobile and lebara websites is to get a report as PDF download.Thus we deal with PDF as input.

# Design
1. - [ ] Download account statement(s) from Lycamobile (or Lebara) and copy them to TestData Directory
    * Input: Lycamobile login details of user.
    * Output: PDF call logs file(s).
2. - [x] Convert PDF to TXT document.
    * Input: PDF call logs file
    * Output: Raw TXT file with calls logs and other irrelevant information.
3. - [x] Filter the data records 
    * Input: Raw TXT file with calls logs and other irrelevant information.
    * Output: A filtered TXT file with only (Voice) call logs.
4. - [x] Make this txt file parceable for csv.
    * Input: A filtered TXT file with only (Voice) call logs.
    * Output: A csv parceable TXT file.
5. - [x] Convert this csv parceable TXT file to a proper CSV document.
    * Input: A csv parceable TXT file.
    * Output: A proper CSV file with headers.
6. - [x] Get the unique called phone numbers from this csv file.
    * Input: A proper CSV file with headers.
    * Output: An array of Unique phone numbers called by the user.
7. - [x] Get the frequency (count of calls per phone number) from this csv file.
    * Input: A proper CSV file with headers.
    * Output: An array of frequency (count of calls/per phone number).
8. - [x] Get the names from google contacts: [If user has signed up for this](./Secrets/Readme.md)
    * Input: Phone numbers array(point 5) and location of Secrets Json. 
    * Output: An array of Names corresponding to these called numbers.
9. - [x] Make a matrix with these three parameters  
    * Note: Goal is to create this matrix is such a way, that it can be used to create any output format as desired
    * Input: An array of Unique phone numbers; their corresponding frequency array; and their corresponding names
    * Output: A hastable collection array that can be converted to any format (as per the request of user)
10. - [x] Sort this matrix in the descending order of call frequency (since there is value in knowing who we called most to least)
    * Input: An unsorted hashtable array from previous step.
    * Output: A sorted hashtable array.
11. - [x] Display the result as json/csv/table (what you like)
    * Input: A sorted hastable collection array that can be converted to any format (as per the request of user)
    * Output: Based on the choice made by user in the main.ps1, it could be a JSON/CSV/Table output (All outputs or any combination, possible at any given time)

# Output
1. Type: CSV, JSON, TXT (Table format)
2. You will see in the test results folder
    * ResultAsCSV.csv (code friendly format)
    * ResultAsJSON.json (code friendly format)
    * ResultAsTABLE.txt (most human friendly format)

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
---
**NOTE** : When run from Entrypoint (see dockerfile), this will directly give you results on command line.
- When run from debug-mode(see dockerfile), you would need to run the main.ps1 yourself as shown below.
- PS /circle> ./main.ps1

---

# Execute 
If you want to run the main script with your lycamobile account statement, 
1. Download or clone this repository in one of your drives.
2. Go to lycamobile.nl. Login with your credentials and download your calls logs pdf. 
3. Put this call logs pdf file in TestData repository.
4. Run the main.ps1 script in the root folder of this project.
5. You should see the results in directory './TestResults/*'

# Feature List (to add in future)
* - [x] Option to filter on dates [Not to implement]
    - I have decided to keep this out of the framework. This choice should be done while downloading the reports. Not in framework.
  - [x] Full Instructions on how to run framework.
* - [ ] Option to download data from lycamobile via script.
* - [x] Option to report on more than one pdf statements at the same time.
* - [x] Sort final stats as per CallFrequency (This will show who you call the most on top).
* - [x] Option to show names in final output 
    - (If user chooses to sync his contacts to google contacts from his smart phone and provide a secrets json file in Secrets directory. Steps shared here.)
* - [x] To extend this functionality for both lycamobile and lebara reports.

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
