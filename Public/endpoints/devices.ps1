# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameter_sets?view=powershell-7.2#declaring-parameter-sets
$LNMSDeviceAPIPath="devices"
# Note: These functions are clunky because of the possible valid parameter sets and values the API will accept. 
# No need for $PSBoundParameters.GetEnumerator() on some of these.
function Add-LNMSDevice{
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)]
		[Object]$Connection=$Script:LNMSConnection,

		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='ping')]
		[Parameter(Mandatory = $true, Position = 0,ParameterSetName='snmp')]
		[string]$hostname,

		[Parameter(Mandatory = $true,ParameterSetName='ping')]
		[switch]$pingonly,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[Int32]$snmpPort,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string][ValidateSet("v1","v2c","v3")]$snmpVersion,

		[Parameter(Mandatory = $false,ParameterSetName='ping')]
		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[Parameter(Mandatory = $false)][switch]$force,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string]$snmpCommunity,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string][ValidateSet('noAuthNoPriv','authNoPriv','AuthPriv')]$authlevel,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string]$authname,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string]$authpass,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string][ValidateSet('MD5','SHA')]$authalgo,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string]$cryptopass,

		[Parameter(Mandatory = $false,ParameterSetName='snmp')]
		[string][ValidateSet('AES','DES')]$cryptoalgo
	)
	$deviceObject=@{
		hostname = $hostname
	}
	if ($pingonly) {$deviceObject.snmp_disable = $true}

	if ($force) {$deviceObject.force_add = $true}
	if ($snmpPort) {$deviceObject.port = $snmpPort}
	if ($snmpVersion) {$deviceObject.version = $snmpVersion}
	# version 1 & 2c
	if ($snmpCommunity) {$deviceObject.community = $snmpCommunity}
	# version 3
	if ($authlevel) {$deviceObject.authlevel = $authlevel}
	if ($authname) {$deviceObject.authname = $authname}
	if ($authpass) {$deviceObject.authpass = $authpass}
	if ($authalgo) {$deviceObject.authalgo = $authalgo}

	if ($cryptopass) {$deviceObject.cryptopass = $cryptopass}
	if ($cryptoalgo) {$deviceObject.cryptoalgo = $cryptoalgo}

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/$LNMSDeviceAPIPath/"
		body =  createJson($deviceObject)
	}

	$Result = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if (($Result[0].Gettype()) -eq [System.Management.Automation.ErrorDetails]) {$Result[0].Message}
	else {$Result.devices}

}
function Get-LNMSDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][Alias("ID")][System.Object]$hostname,
		[Parameter(Mandatory = $false, Position = 1)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).Devices
}
function Get-LNMSDevices {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false, Position = 0)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).Devices
}
function Remove-LNMSDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][Alias("ID")][System.Object]$hostname,
		[Parameter(Mandatory = $false, Position = 1)][System.Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Delete'
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).message
}

function Start-LNMSDeviceDiscovery {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][Alias("ID")][System.Object]$hostname,
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
