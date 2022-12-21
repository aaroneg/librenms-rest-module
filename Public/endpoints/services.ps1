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
		URI = "$($Connection.ApiBaseURL)/services/$hostname"
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
		URI = "$($Connection.ApiBaseURL)/services/$($hostname)?$URLParams"
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
		URI = "$($Connection.ApiBaseURL)/services"
	}
	$restParams
	(Invoke-CustomRequest -restparams $restParams -Connection $Connection).services
}
function Remove-LNMSServiceFromHostname {
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

# Not implemented
# function Update-LNMSService ($Service) {}

Export-ModuleMember -Function "*-*"
