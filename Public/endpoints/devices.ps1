# https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_parameter_sets?view=powershell-7.2#declaring-parameter-sets
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
		URI = "$($Connection.ApiBaseURL)/devices/"
		body =  $deviceObject|ConvertTo-Json -Depth 50
	}
	Write-Verbose "$($deviceObject|ConvertTo-Json -Depth 50)"

	$Result = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	if (($Result[0].Gettype()) -eq [System.Management.Automation.ErrorDetails]) {$Result[0].Message}
	else {$Result.devices}

}
function Get-LNMSDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$hostname,
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
		URI = "$($Connection.ApiBaseURL)/devices/$($hostname)"
	}
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).Devices
}
function Remove-LNMSDevice {

}

function Start-LNMSDeviceDiscovery {

}
function Add-LNMSDeviceParents {

}
function Remove-LNMSDeviceParents {

}

function Get-LNMSDeviceParents {
	
}

Export-ModuleMember -Function "*-*"
