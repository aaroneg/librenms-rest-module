function Get-LNMSDeviceGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devicegroups"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).groups
}

<#
# At least in this version, we don't support creating device groups. 
# This would ideally be split into static / dynamic cmdlets because the input is simple for static and complex for dynamic.
# This will likely require the module to be smart enough to construct valid rules and that seems a bit out of scope. -AEG

#function Add-LNMSStaticDeviceGroup {}

#function Add-LNMSDynamicDeviceGroup {}

#>

function Get-LNMSDeviceGroupMemberIDs {
	[CmdletBinding()]
	param(
		[Parameter(Mandatory = $true)][String]$Name,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devicegroups/$name"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).devices
}

# The API documents describe this api route, but the system I was testing against says it doesn't exist.

# function Start-LNMSDeviceGroupMaintenanceWindow {
# 	[CmdletBinding()]
# 	param(
# 		[Parameter(Mandatory = $true)][String]$groupName,
# 		[Parameter(Mandatory = $false)][String]$title,
# 		[Parameter(Mandatory = $false)][String]$notes,
# 		[Parameter(Mandatory = $false)][String]$duration="2:00",
# 		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
# 	)
# 	$MaintenanceWindowObject=[PSCustomObject]@{
# 		duration = $duration
# 	}
# 	if ($title){ $MaintenanceWindowObject|Add-Member -MemberType NoteProperty -Name title -Value $title}
# 	if ($notes){ $MaintenanceWindowObject|Add-Member -MemberType NoteProperty -Name notes -Value $notes}

# 	$restParams= @{
# 		Method = 'POST'
# 		URI = "$($Connection.ApiBaseURL)/devicegroups/$name/maintenance"
# 		body = createJSON($MaintenanceWindowObject)
# 	}
# 	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).devices
# }