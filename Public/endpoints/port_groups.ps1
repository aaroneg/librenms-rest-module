# This confusingly similar endpoint is for actual port groups.

Function Get-LNMSPortGroups {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/port_groups"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.groups
}

Function Get-LNMSPortsInGroup {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $true)][String]$Name,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/port_groups/$name"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject
}

Function New-LNMSPortGroup {
	param (
		[Parameter(Mandatory = $true, Position = 0)][string]$name,
		[Parameter(Mandatory = $false, Position = 1)][string]$desc,
		[Object]$Connection=$Script:LNMSConnection
	)
	$PostJson = createPostJson -Fields ($PSBoundParameters.GetEnumerator())

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/port_groups"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject

}

Function Add-LNMSPortsToGroup {
	param (
		[Parameter(Mandatory = $true, Position = 0)][string]$GroupID,
		[Parameter(Mandatory = $false, Position = 1)][array]$PortIDs,
		[Object]$Connection=$Script:LNMSConnection
	)

	$PostJson = createJson ([PSCustomObject]@{
		port_ids = $PortIDs
	})

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/port_groups/$GroupID/assign"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.status

}
Function Remove-LNMSPortsFromGroup {
	param (
		[Parameter(Mandatory = $true, Position = 0)][string]$GroupID,
		[Parameter(Mandatory = $false, Position = 1)][array]$PortIDs,
		[Object]$Connection=$Script:LNMSConnection
	)

	$PostJson = createJson ([PSCustomObject]@{
		port_ids = $PortIDs
	})

	$restParams= @{
		Method = 'Post'
		URI = "$($Connection.ApiBaseURL)/port_groups/$GroupID/remove"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.status

}

Export-ModuleMember -Function "*-*"
