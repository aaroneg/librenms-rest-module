Function Get-LNMSVlans {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/vlans"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).vlans
}

Function Get-LNMSVlanForDevice {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/$hostname/vlans"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).vlans
}

Function Get-LNMSLinks {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/links"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).links
}

Function Get-LNMSLinksFromHost {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$hostname,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/devices/$hostname/links"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).links
}

Function Get-LNMSLink {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][int]$id,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/links/$id"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).link
}

Function Find-LNMSFDBEntriesByMAC {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$MAC,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/fdb/$MAC"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).ports_fdb
}

Function Get-LNMSFDBEntries {
	[CmdletBinding()]
	param (
		#[Parameter(Mandatory = $True, Position = 0)][string]$MAC,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/resources/fdb"
		body = $PostJson
	}
	(Invoke-CustomRequest -restParams $restParams -Connection $Connection).ports_fdb
}

Export-ModuleMember -Function "*-*"
