@ECHO OFF
:loop
 REG QUERY "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "AutoConfigURL"
 IF %errorlevel%==0 GOTO DELETE
 IF %errorlevel%==1 GOTO END

 
:Delete
 REG DELETE "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v "AutoConfigURL" /f
 timeout /t 30
 goto loop

:END
 timeout /t 30
 goto loop