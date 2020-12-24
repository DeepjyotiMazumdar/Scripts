On Error Resume Next

dim oSMSClient
 
set oSMSClient = CreateObject ("Microsoft.SMS.Client")
 
if Err.Number <>0 then 
            wscript.echo "Could not create SMS Client Object - quitting"
end if
oSMSClient.SetAssignedSite "ZE1",0
set oSMSClient=nothing
 
