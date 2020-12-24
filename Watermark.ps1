   Function Write-ImageWaterMark 
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
      HelpMessage="A path to watermark image")] 
      [string]$watermark, 
       
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$True, 
      HelpMessage="A path to target image")] 
      [string]$TargetImage, 
       
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$False, 
      HelpMessage="Percentage starting point for watermark 0=left 100=right")] 
      [ValidateRange( 0, 100)] 
      [int32]$widthStart=100, 
       
      [Parameter( 
      ValueFromPipeline=$False, 
      Mandatory=$False, 
      HelpMessage="Percentage starting point for watermark 0=top 100=bottom")] 
      [ValidateRange(0, 100)] 
      [int32]$heightStart=100       
      )       
      
    [void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")   
       
    #load image into memory  
    $i = new-object System.Drawing.Bitmap $SourceImage 
    $i2=$i 
    $height = $i.height 
    $width = $i.width 
     
    #load watermark into memory  
    $w = new-object System.Drawing.Bitmap $watermark 
    $wHeight = $w.height 
    $wWidth = $w.width 
     
    #set target pixel location.     
    $xfix=[math]::Floor(($widthStart/100)*$width) 
    if ($xfix -gt $width-$wWidth){$xfix=$width-$wWidth} 
    $yfix=[math]::Floor(($heightStart/100)*$height) 
    if ($yfix -gt $height-$wHeight){$yfix=$height-$wHeight} 
 
    #loop through all pixels in watermark 
    do  
    { 
       for ($x=0; $x -lt $wWidth; $x++) 
       { 
          for ($y=0; $y -lt $wHeight; $y++) 
          { 
             #Get watermark image pixels 
             $wA=$w.getpixel($x, $y).A 
             $wR=$w.getpixel($x, $y).R 
             $wG=$w.getpixel($x, $y).G 
             $wB=$w.getpixel($x, $y).B 
              
             #reduce the brightness of the watermark 
             $o=$wA/255 
             $wR=[math]::Floor($wR/4*$o) 
             $wG=[math]::Floor($wG/4*$o) 
             $wB=[math]::Floor($wB/4*$o) 
              
             #set target area pixels 
             $xt=$xFix+$x 
             $yt=$yFix+$y 
              
             #Get pixels from source image 
             $A=$i.getpixel($xt, $yt).A 
             $R=$i.getpixel($xt, $yt).R 
             $G=$i.getpixel($xt, $yt).G 
             $B=$i.getpixel($xt, $yt).B 
               
             #create new colours  
             $nR=$wR+$R; if ($nR -gt 255){$nR=255} 
             $nG=$wG+$G; if ($nG -gt 255){$nG=255} 
             $nB=$wB+$B; if ($nB -gt 255){$nB=255} 
              
             #add watermark pixels to target image 
             $colour=[System.Drawing.Color]::FromArgb($A,$nR,$nG,$nB) 
             $i2.setpixel($xt,$yt,$colour)          
          } 
       }        
    } 
    until 
    ($wHeight -eq $y -and $wWidth -eq $x)     
 
    $i2.Save($TargetImage) 
     
    $i.dispose() 
    $w.dispose() 
    $i2.dispose() 
     
    [gc]::collect() 
    [gc]::WaitForPendingFinalizers()     
} 
 
 

 
Write-ImageWaterMark -watermark "C:\Users\dmazumd\Desktop\LG Export\20200328-DSC_0118.jpg" -SourceImage "C:\Users\dmazumd\Desktop\LG Export\DSC_0128.jpg" -TargetImage "c:\newimage.jpg"  
 