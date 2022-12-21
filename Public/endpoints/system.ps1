$LNMSSystemPath="system"
Function Get-LNMSSystem {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $false)]
		[Object]$Connection=$Script:LNMSConnection
	)

	$restParams= @{
		Method = 'Get'
		URI = "$($Connection.ApiBaseURL)/$LNMSSystemPath"
		body = $PostJson
	}
	$PostObject = Invoke-CustomRequest -restParams $restParams -Connection $Connection
	$PostObject.System
}

Export-ModuleMember -Function "*-*"
