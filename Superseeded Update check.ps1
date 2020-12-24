

# Table name
$tabName = “Report”

# Creating head style
$Head = @"
  
<style>
  body {
    font-family: "Arial";
    text-align: center;
    font-size: 8pt;
    color: #4C607B;
    }
  table, th, td { 
    border: 2px solid #e57300;
    border-collapse: collapse;
    padding: 5px;
    }
table {
    margin: 0 auto;
}
  th {
    font-size: 1.2em;
    text-align: center;
    background-color: #003366;
    color: #ffffff;
    }
  td {
    color: #000000;
    }
  tr:nth-child(even) { background: #ffffff; }
  tr:nth-child(odd) { background: #bfbfbf; }
  
 
</style>
  
"@
 
# Create Table object
$table = New-Object system.Data.DataTable “$tabName”
 
# Define Columns
$col1 = New-Object system.Data.DataColumn "Old KB",([string])
$col2 = New-Object system.Data.DataColumn "New KB",([string])
$col3 = New-Object system.Data.DataColumn "Website",([string])

 
# Add the Columns
$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)

$Year = get-date –f yyyy
$Month = get-date –f MM
$Fullmonth = (Get-Culture).DateTimeFormat.GetMonthName($Month)
$c = $Year + $Month
$file = "Rating Windows Server Security Fixes " +$c+"_CSx.xlsx"
$user = $Env:USERPROFILE
$g=(Get-Date).ToString('ddMMyyyy-hhmmss')
$outfile = "testlog-" + $g + ".html"


# Accessing the excel file
$filename = Get-ChildItem -Path "\\Emea.corpdir.net\estr\public\_General\VCT_Server_CG_Wintel\03_Themen\Release Mgmt - Releases\Patch Releases\Ratings\$File" 
$filename = $filename.fullname
$objExcel = New-Object -ComObject Excel.Application
$objExcel.Visible=$false
$objExcel.DisplayAlerts = $False
$workbook = $objExcel.Workbooks.Open($filename)
#$sheetname = @($WorkBook.sheets | Select-Object -Property Name -ExpandProperty Name | Out-GridView -PassThru  -Title 'Choose the Month' )
$sheetname = "$Fullmonth $year"
$Worksheet = $workbook.sheets.Item("$sheetname")
$rowName =2
$colName =2





$rowMax = ($worksheet.UsedRange.Rows).count

for ($i=0; $i -le $rowMax-1; $i++)
{
    $result = $worksheet.Cells.Item($rowName+$i,$colName).text
    If($result -ne "")
    {

    $a = 'https://www.catalog.update.microsoft.com/ScopedViewInline.aspx?updateid='
    $z = 'https://www.catalog.update.microsoft.com/Search.aspx?q='
    $y = $z + $result
    $webpage = Invoke-WebRequest –Uri $y
    $s = $webpage.links | where {($_.innerHTML -like "*Windows Server 2008 R2 for x64-based Systems*" -or $_.innerHTML -like "*Windows Server 2016 for x64-based Systems*"  -or $_.innerHTML -like "*Windows Server 2012 R2 for x64-based Systems*" -or $_.innerHTML -like "*Windows Server 2019 for x64-based Systems*")} | Select onclick -ExpandProperty onclick
    $s = $s.remove(0,13)
    $updateID = $s.remove(36,3)
    $b = $a + $updateID
    $c =  Invoke-WebRequest –Uri $b
    $myPSObject = $c.ParsedHtml.getElementByID("supersededbyInfo")
    cls
    $d = $myPSObject.textcontent
   
   

    # Create a row
        $row = $table.NewRow()
  
        # Enter data in the row
        $row."Old KB" = ($result)
        $row."New KB" = ($d)

         if($d -eq 'n/a')
    {
         $row."Website" = ('')
    }
        
        else 
        {
        $row."Website" = ($b)
        }
       
 
        # Add the row to the table
        $table.Rows.Add($row)

  
      
 }}

  [string]$body = [PSCustomObject]$table | select -Property "Old KB","New KB","Website" | sort -Property "Old KB"  | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h2>Update Info Report</h4></font>"  >> $user\Desktop\$outfile

$objExcel.quit()

invoke-Expression "$user\Desktop\$outfile"




#Send Email 
$strParamStatusMailFrom = "vct-Wintel-updatecheck@daimler.com"
$StrRecepient = "deepjyoti.mazumdar@daimler.com"
$strParamStatusMailSMTPServer = "53.151.100.102" 
Send-MailMessage -From $strParamStatusMailFrom -To $StrRecepient -Subject "Update Check Report" -BodyAsHtml $body -SmtpServer $strParamStatusMailSMTPServer  