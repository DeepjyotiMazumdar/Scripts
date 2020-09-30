Function Write-TextWaterMark 
{ 

   [CmdletBinding()] 
 
   Param ( 
 
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$True, 
      HelpMessage="A path to original image")] 
      [string]$SourceImage, 
       
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$True, 
      HelpMessage="A path to target image")] 
      [string]$TargetImage, 
       
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$True, 
      HelpMessage="Text to write on image")] 
      [string]$MessageText 
 
      ) 
 

    [Reflection.Assembly]::LoadWithPartialName("System.Drawing") | Out-Null 
 
    #read source image and create new target image 
    $srcImg = [System.Drawing.Image]::FromFile($SourceImage) 
    $tarImg = new-object System.Drawing.Bitmap([int]($srcImg.width)),([int]($srcImg.height)) 
 
    #Intialize Graphics 
    $Image = [System.Drawing.Graphics]::FromImage($tarImg) 
    $Image.SmoothingMode = "AntiAlias" 
 
    $Rectangle = New-Object Drawing.Rectangle 0, 0, $srcImg.Width, $srcImg.Height 
    $Image.DrawImage($srcImg, $Rectangle, 0, 0, $srcImg.Width, $srcImg.Height, ([Drawing.GraphicsUnit]::Pixel)) 
 
    #Write MessageText (10 in from left, 1 down from top, white semi transparent text) 
    $Font = new-object System.Drawing.Font("Verdana", 24) 
    $Brush = New-Object Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 0, 0,100)) 
    $Image.DrawString($MessageText, $Font, $Brush, 1100, 1000) 
     
    #Save and close the files 
    $tarImg.save($targetImage, [System.Drawing.Imaging.ImageFormat]::Bmp) 
    $srcImg.Dispose() 
    $tarImg.Dispose() 
}

$Logfile = $MyInvocation.MyCommand.Path -replace '\.ps1$', '.log' 
 
Start-Transcript -Path $Logfile

$userinfo = (net user $env:USERNAME /domain | Select-String "Full Name") -replace "\s\s+"," " -split " " -replace ","," "
$userinfo = $userinfo[3] + " " + $userinfo[2]
Write-TextWaterMark -SourceImage "C:\Test\1.jpg" -TargetImage "C:\Test\public.jpg"  -MessageText $userinfo
echo "Completed"
Stop-Transcript


