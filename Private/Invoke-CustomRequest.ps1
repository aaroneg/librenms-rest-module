function Invoke-CustomRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $false, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		"X-Auth-Token" = $Connection.ApiKey
		ContentType    = 'application/json'
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers
	}
	catch {
		if ($_.ErrorDetails.Message) {
			Write-Error "Response from $($Connection.Address): $(($_.ErrorDetails.Message|convertfrom-json).message)."
		}
		else {
			$_.ErrorDetails
		}
	}
	$result
}
