#
# Get-LogonWorkstations.ps1
#

Function Get-LogonWorkstations
{
	[CmdletBinding()]
	Param ( 
		[Parameter(Mandatory=$true,Position=0)]
		[ValidateNotNullOrEmpty()]
		[string[]]$ServiceAccount
	)

	# Import AD module
	Begin
	{
		Import-Module ActiveDirectory -Cmdlet Get-Aduser -ErrorAction Stop
	}

	# Try to find AD user account and its logon rights
	Process
	{
		write-verbose "Processing stuff"
		try
		{
			foreach ($_ in $ServiceAccount)
			{
				$ADuser = $null
				$ADuser = Get-Aduser $_ -Properties LogonWorkstations
				if ($ADuser)
				{
					write-host "$_ has logon rights to:"
					if($ADuser.LogonWorkstations -ne $null)
					{
						($ADuser | Select -ExpandProperty LogonWorkstations).Split(',') | Sort
					}
					else
					{
						write-host "All computers."
					}
				}
				else
				{
					write-host "The service account named $_ was not found in active directory."
				}
			}
		}
		catch [Microsoft.ActiveDirectory.Management.ADIdentityNotFoundException]
		{
			Write-Warning "$_"
			BREAK;
		}
	}
	
	End
	{
		write-verbose "The script has finished successfully."
	}
}
