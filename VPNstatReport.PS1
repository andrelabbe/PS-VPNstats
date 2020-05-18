<#
.Synopsis
  This is a script to gather and create a VPN Stat Report as CSV to be emailed to various recipient

.Description
  All credits go to various 'sites' which helped me create this little sript.
  
  You only need to change few variables to fit your need.

  $startDate
    'Past' date to start the report.
    The value is -1 as yesterday.
  $endDate
    'End' date to finish the report.
    The value is Today.
  $fileName
    How do you want to call the file.
    The file will be created into the selected folder and emailed to (various) recipient.
  $fullPathName
    You can select the path where to store the Report's csv. It uses the $fileName as filename.

  The only left to configure are:
    Email TO...
    Email CC...
    SMTP server 
    I did not bother to create variables since they are only used once.
  
  Email Body:
    As you can see it is pretty basic.
    Again the only thing I am interresting is the report and not some fancy HTML. 

.Example

#>
###########Get VPN stat and Email the CSV########
###########Get some variables########
$startDate = [DateTime]::Today.AddDays(-1)
$endDate = [DateTime]::Today
$fileName = $startdate.Tostring("ddMMMyyyy")+"-Today"
$fullPathName = "c:\temp\pipi\${fileName}.csv"
###########Get the VPN stat and save to CSV########
Get-RemoteAccessConnectionStatistics -StartDateTime $startDate -EndDateTime $endDate | Select-Object -Property ClientIPv4Address,ClientExternalAddress,ClientIPAddress,ConnectionDuration,ConnectionStartTime,TotalBytesIn,TotalBytesOut,SessionId,UserName | export-csv -path $fullPathName -NoTypeInformation
###########create email and send########
$message = new-object System.Net.Mail.MailMessage 
$message.From = "administrator@somedomain.co.uk" 
$message.To.Add("john.doe@somedomain.co.uk")
$message.CC.Add("admin.user@somedomain.co.uk") 
$message.IsBodyHtml = $False 
$message.Subject = "VPN Stat"
$attach = new-object Net.Mail.Attachment($fullPathName) 
$message.Attachments.Add($fullPathName) 
$message.body = "Hi, VPN Stat" 
$smtp = new-object Net.Mail.SmtpClient("somedomain-co-uk.mail.protection.outlook.com") 
$smtp.Send($message) 
###########All done######## 

