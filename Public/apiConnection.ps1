function New-LNMSConnection {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$True,Position=0)][string]$DeviceAddress,
        [Parameter(Mandatory=$True,Position=1)][string]$ApiKey,
        [Parameter(Mandatory=$false)][string]$ApiVersion='0',
        [Parameter(Mandatory=$false)][bool]$SkipCertificateCheck=$True,
        [Parameter(Mandatory=$false)][switch]$Passthru
	)
	#$MyInvocation.MyCommand.Parameters

	$ConnectionProperties = @{
		Address = "$DeviceAddress"
		ApiKey = $ApiKey
		ApiVersion = $ApiVersion
		ApiBaseURL = "https://$($DeviceAddress)/api/v$($ApiVersion)"
	}
	$LNMSConnection = New-Object psobject -Property $ConnectionProperties
	Write-Verbose "[$($MyInvocation.MyCommand.Name)] Host '$($LNMSConnection.Address)' is now the default connection."
	$Script:LNMSConnection = $LNMSConnection
	if ($Passthru) {
		$LNMSConnection
	}
}

function Test-LNMSConnection {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline=$true,Mandatory=$false,Position=0)][object]$LNMSConnection=$Script:LNMSConnection
	)
	if(!($LNMSConnection)) { "Trying default connection" }

	$restParams=@{
		Method = 'Get'
		Uri = "$($LNMSConnection.ApiBaseURL)/"
	}

	Invoke-CustomRequest -restparams $restParams -Connection $LNMSConnection
}

function Get-LNMSCurrentConnection {
    "Here is the current default connection:"
    $Script:LNMSConnection
}

function Reset-LMNSModule {
	Import-Module -Name librenms-rest-module -Force
}

Export-ModuleMember -Function "*-*"