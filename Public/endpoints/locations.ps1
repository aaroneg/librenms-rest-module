Function Get-LNMSLocations {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/locations"
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).locations
}

Function New-LNMSLocation {
	param (
		[Parameter(Mandatory = $true, Position = 0)][string]$location,
		[Parameter(Mandatory = $false, Position = 1)][string]$lat,
		[Parameter(Mandatory = $false, Position = 2)][string]$lng,
		[Object]$Connection=$Script:LNMSConnection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/locations"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject

}

Function Remove-LNMSLocation {
	param (
		[Parameter(Mandatory = $true, Position = 0)][string]$location,
		[Object]$Connection=$Script:LNMSConnection
	)
	
	$restParams= @{
		Method = 'DELETE'
		URI = "$($Connection.ApiBaseURL)/locations/$location"
		body = $PostJson
	}
	Invoke-CustomRequest -restParams $restParams -Connection $Connection
	
}

Export-ModuleMember -Function "*-*"
