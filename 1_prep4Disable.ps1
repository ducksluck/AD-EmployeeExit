########################################################################################################################
#
# **This is to be run via Exchange Management Shell before disableUser.ps1 in order to modify mailbox properties, such as
#        Mail Forwaring, Hide from GAL, or any other Exchange specific settings. 
#
#
# In order to run:
#
#   1) login to a Domain Controller which the list of users reside. 
#
#   2) Run powershell ISE and paste contents of extendExpired.ps1
##################################################################################################################


#TODO:
#reset user password to something random.
#send restriction to 1 KB **ONLY** if they don't have email forward.
#Forward email **if requested** to requested management and mailbox(retain copy)


Import-Module ActiveDirectory

$userlist = Import-Csv ".\toDisable.csv" -Header Name,Date


foreach ($line in $userlist) {  
 
    try { 
        $line
		Set-Mailbox -Identity $line.Name -MaxSendSize 1KB
        Set-Mailbox -Identity $line.Name -HiddenFromAddressListsEnabled $true
    }
    catch { $line.Name | Out-File '.\preErrors.csv' -Append }
}
