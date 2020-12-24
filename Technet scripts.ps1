[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$StrMainWebsite = "https://gallery.technet.microsoft.com"
$web = $Server = Read-Host -Prompt 'Paste the weblink'
$page = Read-Host -Prompt 'Enter the number of pages' 

#Iterating through all the pages
For ($i=6; $i -le $page+$i; $i++) 

{
$website = $web + "&pageIndex=" + $i
$tempwebpage = Invoke-WebRequest –Uri $website
$webpage = $tempwebpage.Links | where-Object {$_.href -Like "/scriptcenter/*" -And $_.href -NotLike "*site*" -and $_.href -NotLike "*.aspx"}

#Iterating through all the links parent in the page

Foreach($l in $webpage.href)
{

$site = Invoke-WebRequest –Uri ($strMainwebsite + $l)
$link = $site.links | Where-Object {$_.href -like “*.ps1*”}
Write-Host "Templink : " $templink -ForegroundColor White
if(!([string]::IsNullorEmpty($link)))
{
$templink = $link.'data-url'.split(' ')[0]
$final = $StrMainWebsite + $templink
#Saving the file with a file name 
@($final).foreach(
{
$fileName = $_ | Split-Path -Leaf
Write-Host "Downloading script file $fileName from Page: $i " -ForegroundColor Yellow
Invoke-WebRequest -Uri $_ -OutFile "C:\temp\$fileName"
Write-Host "Script Download complete : $filename" -ForegroundColor Yellow
}
)
}
}
}

Write-Host 'Script execution complete !!!. Opening the download folder' -ForegroundColor Green
ii "C:\temp"