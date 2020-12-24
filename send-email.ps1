
$strParamStatusMailFrom = "deepjyoti.mazumdar@technohome.co.in"
$StrRecepient = "deepjyoti.mazumdar@daimler.com"
$strParamStatusMailSMTPServer = "mail.smtp2go.com"

send-MailMessage -From $strParamStatusMailFrom -To $StrRecepient -Subject "oOSD  finished " -Body "Test"  -SmtpServer $strParamStatusMailSMTPServer -Port "80" -Credential deep.cse2008@gmail.com