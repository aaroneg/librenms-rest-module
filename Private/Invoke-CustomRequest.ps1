function Invoke-CustomRequest {
	[CmdletBinding()]
	param (
		[Parameter(Mandatory = $True, Position = 0)][System.Object]$restParams,
		[Parameter(Mandatory = $True, Position = 1)][System.Object]$Connection
	)
	$Headers = @{
		"X-Auth-Token" = $Connection.ApiKey
		ContentType    = 'application/json'
	}
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Making API call."
	try {
		$result = Invoke-RestMethod @restParams -Headers $headers
		$result
	}
	catch {
		$ErrObj=$_.ErrorDetails.Message|ConvertFrom-Json
		if ($ErrObj.Status -eq 'error') { Throw $ErrObj.Message}
		else {Write-Warning $ErrObj.Message}
	}

}
