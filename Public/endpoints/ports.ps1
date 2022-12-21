# Not implemented:
# get_all_ports
# search_ports


function Get-LNMSPortsForMACFromFDB {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][string]$MAC,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/ports/mac/$MAC"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.ports
}

function Get-LNMSPortByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][int]$PortID,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/ports/$PortID"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.port
}

function Get-LNMSPortIPInfoByID {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][int]$PortID,
		[Parameter(Mandatory = $false)][Object]$Connection=$Script:LNMSConnection
	)
	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/ports/$PortID/ip"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.addresses
}

Export-ModuleMember -Function "*-*"

