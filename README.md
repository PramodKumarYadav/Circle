# Circle :phone:

The idea behind the project is to see how our social health is. We have hundreds of contacts in our call list and yet there are often a handful of people we call.

This tool, will give you insight on who in your friends and family are most closest to you and thus by contrast, who are the people who were once very close to you but you never or seldom call them.

Hope this insight, helps you with what you want to do with this information. 

# Scope
Since I have a lycamobile connection, the scope of the project (atleast at this moment) is to parse lyca mobile call logs and create insights from it.

However, I think once I am done with it, with minor modifications, you would be able to run it for your telephone statements as well with other service providers as well.

# Design
1 - [ ] Download account statement from Lycamobile 
    * The only option is to get a PDF download.
2 - [ ] Convert pdf to txt document.
3 - [ ] Filter out the column names and data records 
    * There is other unnecessary information as well. We need to filter that out.
4 - [ ] Convert this filtered information into a csv file that we can now work with.
5 - [x] Get the unique called phone numbers from this csv file.
6 - [x] Get the frequency (count of calls per phone number) from this csv file.
7 - [x] Make a matrix with these two parameters 
    * Goal is to create this matrix is such a way, that it can be used to create any output format as desired
8 - [x] Display the result as json/csv/table (what you like)

# Execute 
To run this code, download the project and run main.ps1
Dummy project will run with the data in the file @ TestData/numbers.csv
If you want to run with your real life data, 
-> Go to lycamobile.nl. Download your calls logs pdf. 
-> Run this code to convert pdf to csv (details to be added)
-> Trim unneccessary information (details to be added)
-> Once you have a proper csv file, copy and put it in the TestData folder say as TestData/myCallLogs.csv
-> you can run the main.ps1 file now by giving this file name in the function mentioned in main.
    Get-Circle -PathOfCSV "$currentDir\TestData\myCallLogs.csv"
-> You should now see results in powershell window (and I will add the summary to a out file in TestResults folder in due time)

# Reference read me file
[Named Link](https://github.com/tchapi/markdown-cheatsheet/blob/master/README.md "Readme markdown-cheatsheet")
[Named Link](https://www.webfx.com/tools/emoji-cheat-sheet/ "emoji-cheat-sheet")



