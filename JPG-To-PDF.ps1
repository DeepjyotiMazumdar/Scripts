$scandir="C:\Users\dmazumd\Desktop\My Stufff\Income Tax 2020"
$scanlogdir="C:\Users\dmazumd\Desktop\My Stufff\Income Tax 2020"
$printername= "Microsoft Print to PDF"

# Cleanup old pdf files - Change AddDays value as required
Get-ChildItem "$scanbdir\*.jpg" | ? {LastWriteTime -LT (Get-Date).AddDays(-15)} | Remove-Item -Confirm:$false

# Create a Log file $scanlogname
$scanlogname = Join-Path -Path $scanlogdir -ChildPath "$(Get-Date -Format 'MM-dd-yyyy').log"

# Get the List of files in the Directory
echo "$(get-date) - Checking for any scanned pdf files in $scandir" | Out-File -Append $scanlogname

(Get-WmiObject -ComputerName localhost -Class Win32_Printer -Filter "Name='Microsoft Print to PDF'").setdefaultprinter()

Get-ChildItem -Path $scandir -filter "*.jpg" | % {

Start-Process -FilePath $_.VersionInfo.FileName –Verb print

#out-printer -InputObject $scandir\$pdftoprint $printername

"$(get-date) - Printing file - $_ on Printer - $printername" | Out-File -Append $scanlogname
}