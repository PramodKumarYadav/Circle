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

# Requirements
* Windows OS with Powershell 5 or more installed on it.
* Having lycamobile login credentials to be able to download pdf statements from their website.

# Execute with Dummy data
* To run this code with dummy data, download the project and run main.ps1
    * Dummy project will run with the data in the file @ TestData/OriginalPDF2CSVConvertedFile.csv

# Execute with Real data (Your lycamobile statement)
If you want to run with your real life data, 
1. Go to lycamobile.nl. Login with your credentials and download your calls logs pdf. 
2. You can convert the pdf to a csv file using this website: https://pdftables.com/
3. Download or clone this repository in one of your drives.
4. Copy the csv file created in step 2 to TestData directory with name 'OriginalPDF2CSVConvertedFile.csv'
5. Run the main.ps1 script in the root folder of this project.
6. You should see the results in directory './TestResults/*'

# Reference
* [Readme markdown-cheatsheet](https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md "Readme markdown-cheatsheet")
* [emoji-cheat-sheet](https://www.webfx.com/tools/emoji-cheat-sheet/ "emoji-cheat-sheet")

I first tried below option but due to limited option to use this free only for first 50 pages, I couldnt use this anymore. 
Worked Okay but discarded due to the fact that I want to try open source solutions. Keeping here for reference, in case if a project pays to use this for a use case of pdf2csv conversion. 
* [powershell-pdftables-api](https://github.com/pdftables/powershell-pdftables-api )
* [To-get-your-API-key-from-PDFTables](https://pdftables.com/pdf-to-excel-api)
* [how-to-sign-external-scripts-to-be-able-to-run-on-your-system](https://devblogs.microsoft.com/scripting/hey-scripting-guy-how-can-i-sign-windows-powershell-scripts-with-an-enterprise-windows-pki-part-2-of-2/)




