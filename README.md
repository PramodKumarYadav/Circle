# Circle
This project is to parse lyca mobile call logs and give me information about who do I call and how frequently.

Since I am using lycamobile, the project is customised around it. However, I think once I am done with it, with minor modifications, you would be able to run it for your telephone statements as well.

# Design
-> [ToDo] Download account statement from Lycamobile 
    -> The only option is to get a PDF download.
-> [ToDo] Convert pdf to txt document.
-> [ToDo] Filter out the column names and data records 
    -> There is other unnecessary information as well. We need to filter that out.
-> [ToDo] Convert this filtered information into a csv file that we can now work with.
-> [Done] Get the unique called phone numbers from this csv file.
-> [Done] Get the frequency (count of calls per phone number) from this csv file.
-> [Done] Make a matrix with these two parameters 
    -> Goal is to create this matrix is such a way, that it can be used to create any output format as desired
-> [Done] Display the result as json/csv/table (what you like)

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

