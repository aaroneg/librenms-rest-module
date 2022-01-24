function Get-ApiItem {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:apiConnection,
        [parameter(Mandatory = $true)][string]$RelativePath,
        [parameter(Mandatory = $true)][string]$Name
    )
    $ObjectAPIURI = "$($apiConnection.ApiBaseUrl)$($RelativePath)?"
    $Arguments = @{
        location = $Location
        name = $Name
    }
    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    (Invoke-PaRequest $restParams).result.entry
}

function Get-ApaItems {
    [CmdletBinding()]
    Param(
        [parameter(Mandatory = $false)][object]$apiConnection = $Script:apiConnection,
        [parameter(Mandatory = $true)][string]$RelativePath
    )
    $ObjectAPIURI = "$($apiConnection.ApiBaseUrl)$($RelativePath)?"

    $Arguments = @{
        location = $Location
        name = $Name
    }

    $Argumentstring = (New-PaArgumentString $Arguments)
    $restParams = @{
        Method               = 'get'
        Uri                  = "$($ObjectAPIURI)$($ArgumentString)"
        SkipCertificateCheck = $apiConnection.SkipCertificateCheck
    }
    (Invoke-PaRequest $restParams).result.entry
}

Export-ModuleMember -Function "*-*"