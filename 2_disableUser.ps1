#Disable user(s) and move to Jail.

########################################################################################################################
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

$ascii=$NULL;For ($a=33;$a –le 126;$a++) {$ascii+=,[char][byte]$a }


foreach ($line in $userlist) {  
 
    try { 
    
    #Set Expiration Date
    Set-ADAccountExpiration -Identity $line.Name -Date (Get-Date).AddDays(-1).ToString('MM-dd-yyyy')
    
    #Generate Password
    $pwd = GET-Temppassword –length 43 –sourcedata $ascii
    Set-AdUserPwd -user $line.Name -pwd $pwd

    #Move user to Jail OU:
    Get-ADUser $line.Name| Move-ADObject -TargetPath 'OU=Jail,DC=domain,DC=domain,DC=domain'

    #Disable User
    Set-ADUser -Identity $line.Name -Enabled $False -Description "User disabled, contact Service Desk"

    }

    catch { $line.Name | Out-File '.\disableErrors.csv' -Append }

}



Function GET-Temppassword() {

Param(

[int]$length=10,

[string[]]$sourcedata

)

 

For ($loop=1; $loop –le $length; $loop++) {
    $TempPassword+=($sourcedata | GET-RANDOM)
}

return $TempPassword

}



#GET-Temppassword Created by:
#http://blogs.technet.com/b/heyscriptingguy/archive/2013/06/03/generating-a-new-password-with-windows-powershell.aspx