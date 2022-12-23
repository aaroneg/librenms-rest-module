# This endpoint is only partially implemented

Function Get-LNMSDeviceLog {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $False, Position = 1)][int]$limit=20,
		[Parameter(Mandatory = $False, Position = 2)][string]
		[ValidateSet("event","sys","alert")]
		$logtype="event",
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/logs/$($logtype)log/$($hostname)?limit=$limit&sortorder=DESC"
		body = $PostJson
	}
	Write-Verbose $restParams.URI
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).Logs
}



Export-ModuleMember -Function "*-*"
