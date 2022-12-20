$LNMSServiceAPIPath="services"
function Add-LNMSServiceToDevice{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true, Position = 0)]
		[string]$hostname,
		[Parameter(Mandatory = $true, Position = 1)]
		[string]$type,
		[Parameter(Mandatory = $false)]
		[string]$ip,
		[Parameter(Mandatory = $false)]
		[string]$desc,
		[Parameter(Mandatory = $false)]
		[string]$param,
		[Parameter(Mandatory = $false)]
		[switch]$ignore,
		[Parameter(Mandatory = $false)]
		[Object]$Connection=$Script:LNMSConnection
	)

	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$LNMSServiceAPIPath/$hostname"
		body = $PostJson
	}

	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if (($PostObject[0].Gettype()) -eq [System.Management.Automation.ErrorDetails]) {$PostObject[0].Message}
	$PostObject

}
function Get-LNMSServiceForHostname {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $False, Position = 1)][int]$state,
		[Parameter(Mandatory = $False, Position = 2)][string]$type,
		[Parameter(Mandatory = $False)][Object]$Connection=$Script:LNMSConnection
	)
	$Filters=@()
	if($state) {$Filters.Add("state=$state")}
	if($type)  {$Filters.Add("type=$type")}
	$URLParams=$Filters -join '&'
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$LNMSServiceAPIPath/$($hostname)?$URLParams"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection)
}
function Get-LNMSServices {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false, Position = 0)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$LNMSServiceAPIPath"
	}
	$restParams
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).services
}
function Remove-LNMSDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$hostname,
		[Parameter(Mandatory = $false, Position = 1)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection)
}

function Start-LNMSDeviceDiscovery {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$hostname,
		[Parameter(Mandatory = $false, Position = 1)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)/discover"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).result.message
}
function Add-LNMSDeviceParents {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection,
		
		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='names')]
		[string]$hostname,

		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='deviceid')]
		[string]$hostid,

		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='deviceids')]
		[array]$parentIDs,

		[Parameter(Mandatory = $true, Position = 1,ParameterSetName='names')]
		[array]$parentHostnames

	)
	[string]$parentList = $parentIDs -join ','
	$deviceObject=@{
		parent_ids = $parentList
	}
	
	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)/parents"
		body =  $deviceObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose "$($deviceObject|ConvertTo-Json -Depth 50)"

	$Result = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if (($Result[0].Gettype()) -eq [System.Management.Automation.ErrorDetails]) {$Result[0].Message}
	else {$Result.message}
}
function Remove-LNMSDeviceParents {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection,
		[Parameter(Mandatory = $true, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $true, Position = 1)][array]$parentIDs=$null
	)
	$deviceObject=@{
		parentids = $parentIDs
	}

	$restParams= @{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)/parents"
		body =  $deviceObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose "$($deviceObject|ConvertTo-Json -Depth 50)"

	$Result = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if (($Result[0].Gettype()) -eq [System.Management.Automation.ErrorDetails]) {$Result[0].Message}
	else {$Result.message}
}

function Get-LNMSDeviceParents {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection,
		[Parameter(Mandatory = $true, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $false)][switch]$showHostnames
	)
	$device=Get-LNMSDevice -hostname $hostname -Connection $Connection
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/?type=device&query=$($device.device_id)"
	}
	if ($showHostnames) {(Invoke-CustomRequest -restparams $restParams -Connection $Connection).Devices.dependency_parent_hostname}
	else {(Invoke-CustomRequest -restparams $restParams -Connection $Connection).Devices.dependency_parent_id}
}

Export-ModuleMember -Function "*-*"
