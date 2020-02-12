# Disable / Jail AD user account
Example scripts for disabling a list of user account in Active Directory

List should be a csv with one username per line.

The Prep scipt is for things that should be updated before account is disabled and jailed, such as:
   -Set-Mailbox -Identity $line.Name -MaxSendSize 1KB
   -Set-Mailbox -Identity $line.Name -HiddenFromAddressListsEnabled $true

The Disable User Script then does things such as:
   -Set Expiration Date
   -Generate Random Password
   -Move user to Jail OU
   -Disable User


