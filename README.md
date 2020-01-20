# :phone: Circle 

The idea behind the project is to see how our social health is. We have hundreds of contacts in our call list and yet there are often a handful of people we call.

This tool, will give you insight on who in your friends and family are most closest to you and thus by contrast, who are the people who were once very close to you but you never or seldom call.

Hope this helps in bringing friends and family closer to you.

# Scope
Since I have a lycamobile connection, the scope of the project (atleast at this moment) is to parse lyca mobile call logs and create insights from it.
However, I think once I am done with it, with minor modifications, you would be able to run it for your telephone statements as well with other service providers as well.

# Design
1. - [ ] Download account statement from Lycamobile 
    * Note: The only option is to get a PDF download.
    * Input: Lycamobile login details of user.
    * Output: PDF call logs file.
2. - [ ] Convert pdf to txt document.
    * Input: PDF call logs file
    * Output: CSV file with calls logs and some irrelevant information.
3. - [x] Filter out the column header record and data records 
    * Input: CSV file with calls logs and some irrelevant information.
    * Output: A proper CSV file with all call logs (Data/Voice) information.
4. - [x] Convert this filtered information into a csv file that we can now work with.
    * Input: A proper CSV file with all call logs (Data/Voice) information.
    * Output: A proper CSV file with only relevant information for call analysis i.e. (Voice) records.
5. - [x] Get the unique called phone numbers from this csv file.
    * Input: A proper CSV file with only relevant information for call analysis i.e. (Voice) records.
    * Output: An array of Unique phone numbers called by the user.
6. - [x] Get the frequency (count of calls per phone number) from this csv file.
    * Input: A proper CSV file with only relevant information for call analysis i.e. (Voice) records.
    * Output: An array of frequency (count of calls/per phone number).
7. - [x] Make a matrix with these two parameters 
    * Note: Goal is to create this matrix is such a way, that it can be used to create any output format as desired
    * Input: An array of Unique phone numbers and their corresponding frequency array
    * Output: A hastable collection array that can be converted to any format (as per the request of user)
8. - [x] Display the result as json/csv/table (what you like)
    * Input: A hastable collection array that can be converted to any format (as per the request of user)
    * Output: Based on the choice made by user in the main.ps1, it could be a JSON/CSV/Table output (All outputs or any combination, possible at any given time)

# Execute 
* To run this code, download the project and run main.ps1
    * Dummy project will run with the data in the file @ TestData/numbers.csv

# Manual Steps
- [] To define yet 
If you want to run with your real life data, 
1. Go to lycamobile.nl. Download your calls logs pdf. 
2. Run this code to convert pdf to csv (details to be added)
3. Trim unneccessary information (details to be added)
4. Once you have a proper csv file, copy and put it in the TestData folder say as TestData/myCallLogs.csv
5. you can run the main.ps1 file now by giving this file name in the function mentioned in main.
    * Get-Circle -PathOfCSV "$currentDir\TestData\myCallLogs.csv"
6. You should now see results in powershell window (and I will add the summary to a out file in TestResults folder in due time)

# Reference
* [Readme markdown-cheatsheet](https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md "Readme markdown-cheatsheet")
* [emoji-cheat-sheet](https://www.webfx.com/tools/emoji-cheat-sheet/ "emoji-cheat-sheet")

I first tried below option but due to limited option to use this free only for first 50 pages, I couldnt use this anymore. 
Worked Okay but discarded due to the fact that I want to try open source solutions. Keeping here for reference, in case if a project pays to use this for a use case of pdf2csv conversion. 
* [powershell-pdftables-api](https://github.com/pdftables/powershell-pdftables-api )
* [To-get-your-API-key-from-PDFTables](https://pdftables.com/pdf-to-excel-api)
* [how-to-sign-external-scripts-to-be-able-to-run-on-your-system](https://devblogs.microsoft.com/scripting/hey-scripting-guy-how-can-i-sign-windows-powershell-scripts-with-an-enterprise-windows-pki-part-2-of-2/)




