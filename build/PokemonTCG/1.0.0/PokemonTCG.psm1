#Region '.\Private\apiCalls\ConvertTo-PokemonTCGQueryString.ps1' -1

function ConvertTo-PokemonTCGQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-PokemonTCGRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-PokemonTCGRequest & any public functions that define parameters

    .PARAMETER uriFilter
        Hashtable of values to combine a functions parameters with
        the resourceURI parameter

        This allows for the full uri query to occur

    .PARAMETER resourceURI
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-PokemonTCGQueryString -uriFilter $uriFilter -resourceURI '/cards'

        Example: (From public function)
            $uriFilter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ) {
                if( $excludedParameters -contains $Key.Key ) {$null}
                else{ $uriFilter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api.pokemontcg.io/v2/cards?q=name:ditto'
            2x key = https://api.pokemontcg.io/v2/cards?q=types:water&select=id,name'

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/ConvertTo-PokemonTCGQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$resourceURI,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uriFilter
)

    begin {}

    process {

        if (-not $uriFilter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages','id'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([string]::Empty)

        ForEach ( $Key in $uriFilter.GetEnumerator() ) {

            if( $excludedParameters -contains $Key.Key ) {$null}
            elseif ( $Key.Value.GetType().IsArray ) {
                Write-Verbose "[ $($Key.Key) ] is an array parameter"
                foreach ($Value in $Key.Value) {
                    $query_Parameters.Add($Key.Key, $Value)
                }
            }
            else{
                $query_Parameters.Add($Key.Key, $Key.Value)
            }

        }

        # Build the request and load it with the query string
        $uri_Request        = [System.UriBuilder]($PokemonTCG_BaseURI + $resourceURI)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}
#EndRegion '.\Private\apiCalls\ConvertTo-PokemonTCGQueryString.ps1' 94
#Region '.\Private\apiCalls\Invoke-PokemonTCGRequest.ps1' -1

function Invoke-PokemonTCGRequest {
<#
    .SYNOPSIS
        Makes an API request

    .DESCRIPTION
        The Invoke-PokemonTCGRequest cmdlet invokes an API request to PokemonTCG API

        This is an internal function that is used by all public functions

        As of 2024-11 the PokemonTCG v2 API only supports GETrequests

    .PARAMETER method
        Defines the type of API method to use

        Allowed values:
        'GET'

    .PARAMETER resourceURI
        Defines the resource uri (url) to use when creating the API call

    .PARAMETER uriFilter
        Used with the internal function [ ConvertTo-PokemonTCGQueryString ] to combine
        a functions parameters with the resourceURI parameter

        This allows for the full uri query to occur

        The full resource path is made with the following data
        $PokemonTCG_BaseURI + $resourceURI + ConvertTo-PokemonTCGQueryString

    .PARAMETER data
        Place holder parameter to use when other methods are supported
        by the PokemonTCG v2 API

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use the page parameter

    .EXAMPLE
        Invoke-PokemonTCGRequest -method GET -resourceURI '/cards' -uriFilter $uriFilter

        Invoke a rest method against the defined resource using any of the provided parameters

        Example:
            Name                           Value
            ----                           -----
            method                         GET
            Uri                            https://api.pokemontcg.io/v2/cards?q=name:ditto
            Headers                        {X-Api-Key = 123456789}
            Body

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Invoke-PokemonTCGRequest.html

#>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [ValidateSet('GET')]
        [string]$method = 'GET',

        [Parameter(Mandatory = $true)]
        [string]$resourceURI,

        [Parameter(Mandatory = $false)]
        [Hashtable]$uriFilter = $null,

        [Parameter(Mandatory = $false)]
        [Hashtable]$data = $null,

        [Parameter(Mandatory = $false)]
        [switch]$allPages

    )

    begin {

        # Load Web assembly when needed as PowerShell Core has the assembly preloaded
        if ( !("System.Web.HttpUtility" -as [Type]) ) {
            Add-Type -Assembly System.Web
        }

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        $query_string = ConvertTo-PokemonTCGQueryString -resourceURI $resourceURI -uriFilter $uriFilter
        Set-Variable -Name $QueryParameterName -Value $query_string -Scope Global -Force -Confirm:$false

        if ($null -eq $data) {
            $body = $null
        } else {
            $body = $data | ConvertTo-Json -Depth $PokemonTCG_JSON_Conversion_Depth
        }

        try {

            if ( [bool](Get-PokemonTCGApiKey) ) {
                $Base64ApiKey = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( $(Get-PokemonTCGApiKey -plainTex)) )
            }

            $parameters = [ordered] @{
                "method"    = $method
                "Uri"       = $query_string.Uri
                "Body"      = $body
            }

            if ($Base64ApiKey) {
                $parameters.Add( "Headers", @{ 'X-Api-Key' = $Base64ApiKey })
            }

            Set-Variable -Name $ParameterName -Value $parameters -Scope Global -Force -Confirm:$false

            if ($allPages) {

                Write-Verbose "Gathering all items from [  $( $PokemonTCG_BaseURI + $resourceURI ) ] "

                $pageNumber = 1
                $allResponseData = [System.Collections.Generic.List[object]]::new()

                do {

                    $parameters['Uri'] = $query_string.Uri -replace 'page=\d+',"page=$pageNumber"

                    $currentPage = Invoke-RestMethod @parameters -ErrorAction Stop

                    Write-Verbose "[ $pageNumber ] of [ $([Math]::Ceiling( $currentPage.totalCount/$currentPage.pageSize )) ] pages"

                        foreach ($item in $currentPage.data) {
                            $allResponseData.add($item)
                        }

                    $pageNumber++

                } while ($([Math]::Ceiling( $currentPage.totalCount/$currentPage.pageSize )) -ne $pageNumber - 1 -and $([Math]::Ceiling( $currentPage.totalCount/$currentPage.pageSize )) -ne 0)

            }
            else{
                $apiResponse = Invoke-RestMethod @parameters -ErrorAction Stop
            }

        }
        catch {

            $exceptionError = $_.Exception.Message
            Write-Warning 'The [ Invoke_PokemonTCGParameters, Invoke_PokemonTCGParametersQuery, & CmdletName_Parameters ] variables can provide extra details'

            switch -Wildcard ($exceptionError) {
                '*402*' { Write-Error "Invoke-PokemonTCGRequest : The parameters were valid but the request failed - [ $($Invoke_PokemonTCGRequest_Parameters.uri.ToString())  ]" }
                '*404*' { Write-Error "Invoke-PokemonTCGRequest : [ $resourceURI ] not found!" }
                '*429*' { Write-Error 'Invoke-PokemonTCGRequest : API rate limited' }
                '*504*' { Write-Error "Invoke-PokemonTCGRequest : Gateway Timeout" }
                default { Write-Error $_ }
            }

        }
        finally {

            $Auth = $Invoke_PokemonTCGRequest_Parameters['headers']['X-Api-Key']
            $Invoke_PokemonTCGRequest_Parameters['headers']['X-Api-Key'] = $Auth.Substring( 0, [Math]::Min($Auth.Length, 9) ) + '*******'

        }


        if($allPages) {

            #Making output consistent
            if( [string]::IsNullOrEmpty($allResponseData.data) ) {
                $apiResponse = $null
            }
            else{
                $apiResponse = [PSCustomObject]@{
                    data        = $allResponseData
                    page        = '1'
                    pageSize    = $null
                    count       = $null
                    totalCount  = ($allResponseData | Measure-Object).Count
                }
            }

            return $apiResponse

        }
        else{ return $apiResponse }

    }

    end {}

}
#EndRegion '.\Private\apiCalls\Invoke-PokemonTCGRequest.ps1' 200
#Region '.\Private\apiKeys\Add-PokemonTCGApiKey.ps1' -1

function Add-PokemonTCGApiKey {
<#
    .SYNOPSIS
        Sets the PokemonTCG API key

    .DESCRIPTION
        The Add-PokemonTCGApiKey cmdlet sets the PokemonTCG API key which is used to
        authenticate all API calls made to PokemonTCG

        An API key is not required to use the PokemonTCG API. However if you aren't using
        an API key, you are rate limited to 1000 requests a day, and a maximum of 30 per minute

        A PokemonTCG API key can be acquired via an account on https://dev.pokemontcg.io/

    .PARAMETER ApiKey
        Defines your API secret key

    .EXAMPLE
        Add-PokemonTCGApiKey

        No API key is set

    .EXAMPLE
        Add-PokemonTCGApiKey -ApiKey '12345'

        Sets the API key to the defined value

    .EXAMPLE
        '12345' | Add-PokemonTCGApiKey

        Sets the API key to the defined value

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGApiKey.html
#>

    [CmdletBinding()]
    [Alias('Set-PokemonTCGApiKey')]
    Param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$ApiKey
    )

    begin {}

    process {

        if ($ApiKey) {
            $x_api_key = ConvertTo-SecureString $ApiKey -AsPlainText -Force

            Set-Variable -Name "PokemonTCG_API_Key" -Value $x_api_key -Option ReadOnly -Scope Global -Force
        }
        else {
            Write-Verbose "Not using an API key will limit queries to 1000 requests a day, and a maximum of 30 per minute"
        }

    }

    end {}
}
#EndRegion '.\Private\apiKeys\Add-PokemonTCGApiKey.ps1' 65
#Region '.\Private\apiKeys\Get-PokemonTCGApiKey.ps1' -1

function Get-PokemonTCGApiKey {
<#
    .SYNOPSIS
        Gets the PokemonTCG API key

    .DESCRIPTION
        The Get-PokemonTCGApiKey cmdlet gets the PokemonTCG API key
        global variable

    .PARAMETER plainText
        Decrypt and return the API key in plain text

    .EXAMPLE
        Get-PokemonTCGApiKey

        Gets the PokemonTCG API key global variable and returns
        it as a SecureString

    .EXAMPLE
        Get-PokemonTCGApiKey -plainText

        Gets the PokemonTCG API key global variable and returns
        it as plain text

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGApiKey.html
#>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $false)]
        [switch]$plainText
    )

    begin {}

    process {

        try {

            if ($PokemonTCG_API_Key) {

                if ($plainText) {
                    $Api_Key = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($PokemonTCG_API_Key)

                    ([System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($Api_Key)).ToString()

                }
                else { $PokemonTCG_API_Key }

            }
            else { Write-Verbose "The PokemonTCG API key is not set. Run Add-PokemonTCGApiKey to set the API key." }

        }
        catch {
            Write-Error $_
        }
        finally {
            if ($Api_Key) {
                [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($Api_Key)
            }
        }


    }

    end {}

}
#EndRegion '.\Private\apiKeys\Get-PokemonTCGApiKey.ps1' 73
#Region '.\Private\apiKeys\Remove-PokemonTCGApiKey.ps1' -1

function Remove-PokemonTCGApiKey {
<#
    .SYNOPSIS
        Removes the PokemonTCG API key

    .DESCRIPTION
        The Remove-PokemonTCGApiKey cmdlet removes the PokemonTCG API key global variable

    .EXAMPLE
        Remove-PokemonTCGApiKey

        Removes the PokemonTCG API key global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Remove-PokemonTCGApiKey.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$PokemonTCG_API_Key) {

            $true   {
                if ($PSCmdlet.ShouldProcess('PokemonTCG_API_Key')) {
                Remove-Variable -Name "PokemonTCG_API_Key" -Scope Global -Force }
            }

            $false  { Write-Warning "The PokemonTCG API key is not set. Nothing to remove" }

        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Remove-PokemonTCGApiKey.ps1' 44
#Region '.\Private\apiKeys\Test-PokemonTCGApiKey.ps1' -1

function Test-PokemonTCGApiKey {
<#
    .SYNOPSIS
        Test the PokemonTCG API key

    .DESCRIPTION
        The Test-PokemonTCGApiKey cmdlet tests the base URI & API key that were defined in the
        Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

    .PARAMETER BaseURI
        Define the base URI for the PokemonTCG API connection using PokemonTCG's URI or a custom URI

        The default base URI is https://api.pokemontcg.io/v2

    .EXAMPLE
        Test-PokemonTCGBaseURI

        Tests the base URI & API key that was defined in the
        Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

        The default full base uri test path is:
            https://api.pokemontcg.io/v2/types

    .EXAMPLE
        Test-PokemonTCGBaseURI -BaseURI http://myapi.gateway.celerium.org

        Tests the base URI & API key that was defined in the
        Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

        The full base uri test path in this example is:
            http://myapi.gateway.celerium.org/types

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Test-PokemonTCGApiKey.html
#>

    [CmdletBinding()]
    Param (
        [parameter(Mandatory = $false, ValueFromPipeline = $true)]
        [string]$BaseURI = $PokemonTCG_BaseURI
    )

    begin { $resourceURI = "/types" }

    process {

        try {

            $PokemonTCG_Headers = New-Object "System.Collections.Generic.Dictionary[[string],[string]]"
            $PokemonTCG_Headers.Add("Content-Type", 'application/json')

            if ( [bool](Get-PokemonTCGApiKey) ) {

            Write-Verbose "Performing API key test against [ $($BaseURI + $resourceURI) ]"

            $Base64ApiKey = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( $(Get-PokemonTCGApiKey -plainTex)) )
            $PokemonTCG_Headers.Add('X-Api-Key', $Base64ApiKey)

            }
            else{ Write-Verbose "Performing test WITHOUT an API key against [ $($BaseUri + $resourceURI) ]" }

            $rest_output = Invoke-WebRequest -method Get -uri ($BaseURI + $resourceURI) -headers $PokemonTCG_Headers -ErrorAction Stop
        }
        catch {

            [PSCustomObject]@{
                method              = $_.Exception.Response.method
                StatusCode          = $_.Exception.Response.StatusCode.value__
                StatusDescription   = $_.Exception.Response.StatusDescription
                Message             = $_.Exception.Message
                URI                 = $($PokemonTCG_BaseURI + $resourceURI)
            }

        }
        finally {
            Remove-Variable -Name PokemonTCG_Headers -Force
        }

        if ($rest_output) {
            $data = @{}
            $data = $rest_output

            [PSCustomObject]@{
                StatusCode          = $data.StatusCode
                StatusDescription   = $data.StatusDescription
                URI                 = $($PokemonTCG_BaseURI + $resourceURI)
            }
        }

    }

    end {}

}
#EndRegion '.\Private\apiKeys\Test-PokemonTCGApiKey.ps1' 98
#Region '.\Private\baseUri\Add-PokemonTCGBaseURI.ps1' -1

function Add-PokemonTCGBaseURI {
<#
    .SYNOPSIS
        Sets the base URI for the PokemonTCG API

    .DESCRIPTION
        The Add-PokemonTCGBaseURI cmdlet sets the base URI which is later used
        to construct the full URI for all API calls

    .PARAMETER BaseURI
        Define the base URI for the PokemonTCG API connection

    .EXAMPLE
        Add-PokemonTCGBaseURI

        The base URI will use https://api.pokemontcg.io/v2 which is
        PokemonTCG's default URI

    .EXAMPLE
        Add-PokemonTCGBaseURI -BaseURI http://myapi.gateway.celerium.org

        A custom API gateway of http://myapi.gateway.celerium.org will be used
        for all API calls to PokemonTCG's API

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGBaseURI.html
#>

    [CmdletBinding()]
    [Alias('Set-PokemonTCGBaseURI')]
    Param (
        [Parameter(Mandatory = $false , ValueFromPipeline = $true)]
        [string]$BaseURI = 'https://api.pokemontcg.io/v2'
    )

    begin {}

    process {

        # Trim superfluous forward slash from address (if applicable)
        if ($BaseURI[$BaseURI.Length-1] -eq "/") {
            $BaseURI = $BaseURI.Substring(0,$BaseURI.Length-1)
        }

        Set-Variable -Name "PokemonTCG_BaseURI" -Value $BaseURI -Option ReadOnly -Scope Global -Force

    }

    end {}

}
#EndRegion '.\Private\baseUri\Add-PokemonTCGBaseURI.ps1' 55
#Region '.\Private\baseUri\Get-PokemonTCGBaseURI.ps1' -1

function Get-PokemonTCGBaseURI {
<#
    .SYNOPSIS
        Shows the PokemonTCG base URI global variable

    .DESCRIPTION
        The Get-PokemonTCGBaseURI cmdlet shows the PokemonTCG base URI
        global variable value

    .EXAMPLE
        Get-PokemonTCGBaseURI

        Shows the PokemonTCG base URI global variable value

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGBaseURI.html
#>

    [CmdletBinding()]
    Param ()

    begin {}

    process {

        switch ([bool]$PokemonTCG_BaseURI) {
            $true   { $PokemonTCG_BaseURI }
            $false  { Write-Warning "The PokemonTCG base URI is not set. Run Add-PokemonTCGBaseURI to set the base URI." }
        }

    }

    end {}

}
#EndRegion '.\Private\baseUri\Get-PokemonTCGBaseURI.ps1' 39
#Region '.\Private\baseUri\Remove-PokemonTCGBaseURI.ps1' -1

function Remove-PokemonTCGBaseURI {
<#
    .SYNOPSIS
        Removes the PokemonTCG base URI global variable

    .DESCRIPTION
        The Remove-PokemonTCGBaseURI cmdlet removes the PokemonTCG base URI
        global variable

    .EXAMPLE
        Remove-PokemonTCGBaseURI

        Removes the PokemonTCG base URI global variable

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Remove-PokemonTCGBaseURI.html
#>

    [CmdletBinding(SupportsShouldProcess)]
    Param ()

    begin {}

    process {

        switch ([bool]$PokemonTCG_BaseURI) {
            $true   { Remove-Variable -Name "PokemonTCG_BaseURI" -Scope Global -Force }
            $false  { Write-Warning "The PokemonTCG base URI variable is not set. Nothing to remove" }
        }

    }

    end {}

}
#EndRegion '.\Private\baseUri\Remove-PokemonTCGBaseURI.ps1' 39
#Region '.\Private\moduleSettings\Export-PokemonTCGModuleSettings.ps1' -1

function Export-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Exports the PokemonTCG BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-PokemonTCGModuleSettings cmdlet exports the PokemonTCG BaseURI, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER PokemonTCGConfPath
        Define the location to store the PokemonTCG configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfFile
        Define the name of the PokemonTCG configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-PokemonTCGModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's PokemonTCG configuration file located at:
            $env:USERPROFILE\PokemonTCG\config.psd1

    .EXAMPLE
        Export-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's PokemonTCG configuration file located at:
            C:\PokemonTCG\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Export-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $PokemonTCGConfig = Join-Path -Path $PokemonTCGConfPath -ChildPath $PokemonTCGConfFile

        # Confirm variables exist and are not null before exporting
        if ($PokemonTCG_BaseURI -and $PokemonTCG_API_Key -and $PokemonTCG_JSON_Conversion_Depth) {
            $secureString = $PokemonTCG_API_Key | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $PokemonTCGConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $PokemonTCGConfPath -ItemType Directory -Force
            }
@"
    @{
        PokemonTCG_BaseURI = '$PokemonTCG_BaseURI'
        PokemonTCG_API_Key = '$secureString'
        PokemonTCG_JSON_Conversion_Depth = '$PokemonTCG_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $PokemonTCGConfig -Force
        }
        else {
            Write-Error "Failed to export PokemonTCG Module settings to [ $PokemonTCGConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Export-PokemonTCGModuleSettings.ps1' 93
#Region '.\Private\moduleSettings\Get-PokemonTCGModuleSettings.ps1' -1

function Get-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Gets the saved PokemonTCG configuration settings

    .DESCRIPTION
        The Get-PokemonTCGModuleSettings cmdlet gets the saved PokemonTCG configuration settings
        from the local system

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfPath
        Define the location to store the PokemonTCG configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfFile
        Define the name of the PokemonTCG configuration file

        By default the configuration file is named:
            config.psd1

    .PARAMETER openConfFile
        Opens the PokemonTCG configuration file

    .EXAMPLE
        Get-PokemonTCGModuleSettings

        Gets the contents of the configuration file that was created with the
        Export-PokemonTCGModuleSettings

        The default location of the PokemonTCG configuration file is:
            $env:USERPROFILE\PokemonTCG\config.psd1

    .EXAMPLE
        Get-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1 -openConfFile

        Opens the configuration file from the defined location in the default editor

        The location of the PokemonTCG configuration file in this example is:
            C:\PokemonTCG\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'index')]
    Param (
        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(Mandatory = $false, ParameterSetName = 'index')]
        [string]$PokemonTCGConfFile = 'config.psd1',

        [Parameter(Mandatory = $false, ParameterSetName = 'show')]
        [switch]$openConfFile
    )

    begin {
        $PokemonTCGConfig = Join-Path -Path $PokemonTCGConfPath -ChildPath $PokemonTCGConfFile
    }

    process {

        if ( Test-Path -Path $PokemonTCGConfig ) {

            if($openConfFile) {
                Invoke-Item -Path $PokemonTCGConfig
            }
            else{
                Import-LocalizedData -BaseDirectory $PokemonTCGConfPath -FileName $PokemonTCGConfFile
            }

        }
        else{
            Write-Verbose "No configuration file found at [ $PokemonTCGConfig ]"
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Get-PokemonTCGModuleSettings.ps1' 89
#Region '.\Private\moduleSettings\Import-PokemonTCGModuleSettings.ps1' -1

function Import-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Imports the PokemonTCG BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-PokemonTCGModuleSettings cmdlet imports the PokemonTCG BaseURI, API, & JSON configuration
        information stored in the PokemonTCG configuration file to the users current session

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfPath
        Define the location to store the PokemonTCG configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfFile
        Define the name of the PokemonTCG configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Import-PokemonTCGModuleSettings

        Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the PokemonTCG configuration file is:
            $env:USERPROFILE\PokemonTCG\config.psd1

    .EXAMPLE
        Import-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the PokemonTCG configuration file in this example is:
            C:\PokemonTCG\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Import-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfFile = 'config.psd1'
    )

    begin {
        $PokemonTCGConfig = Join-Path -Path $PokemonTCGConfPath -ChildPath $PokemonTCGConfFile
    }

    process {

        if ( Test-Path $PokemonTCGConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $PokemonTCGConfPath -FileName $PokemonTCGConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-PokemonTCGBaseURI $tmp_config.PokemonTCG_BaseURI

            $tmp_config.PokemonTCG_API_Key = ConvertTo-SecureString $tmp_config.PokemonTCG_API_Key

            Set-Variable -Name "PokemonTCG_API_Key" -Value $tmp_config.PokemonTCG_API_Key -Option ReadOnly -Scope Global -Force

            Set-Variable -Name "PokemonTCG_JSON_Conversion_Depth" -Value $tmp_config.PokemonTCG_JSON_Conversion_Depth -Scope Global -Force

            Write-Verbose "PokemonTCG Module configuration loaded successfully from [ $PokemonTCGConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $PokemonTCGConfig ] run Add-PokemonTCGApiKey to get started."

            Add-PokemonTCGBaseURI

            Set-Variable -Name "PokemonTCG_BaseURI" -Value $(Get-PokemonTCGBaseURI) -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "PokemonTCG_JSON_Conversion_Depth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Import-PokemonTCGModuleSettings.ps1' 96
#Region '.\Private\moduleSettings\Initialize-PokemonTCGModuleSettings.ps1' -1

#Used to auto load either baseline settings or saved configurations when the module is imported
Import-PokemonTCGModuleSettings -Verbose:$false
#EndRegion '.\Private\moduleSettings\Initialize-PokemonTCGModuleSettings.ps1' 3
#Region '.\Private\moduleSettings\Remove-PokemonTCGModuleSettings.ps1' -1

function Remove-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Removes the stored PokemonTCG configuration folder

    .DESCRIPTION
        The Remove-PokemonTCGModuleSettings cmdlet removes the PokemonTCG folder and its files
        This cmdlet also has the option to remove sensitive PokemonTCG variables as well

        By default configuration files are stored in the following location and will be removed:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfPath
        Define the location of the PokemonTCG configuration folder

        By default the configuration folder is located at:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER andVariables
        Define if sensitive PokemonTCG variables should be removed as well

        By default the variables are not removed

    .EXAMPLE
        Remove-PokemonTCGModuleSettings

        Checks to see if the default configuration folder exists and removes it if it does

        The default location of the PokemonTCG configuration folder is:
            $env:USERPROFILE\PokemonTCG

    .EXAMPLE
        Remove-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -andVariables

        Checks to see if the defined configuration folder exists and removes it if it does
        If sensitive PokemonTCG variables exist then they are removed as well

        The location of the PokemonTCG configuration folder in this example is:
            C:\PokemonTCG

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Remove-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(ParameterSetName = 'set')]
        [switch]$andVariables
    )

    begin {}

    process {

        if (Test-Path $PokemonTCGConfPath) {

            Remove-Item -Path $PokemonTCGConfPath -Recurse -Force -WhatIf:$WhatIfPreference

            If ($andVariables) {
                Remove-PokemonTCGApiKey
                Remove-PokemonTCGBaseURI
            }

            if (!(Test-Path $PokemonTCGConfPath)) {
                Write-Output "The PokemonTCG configuration folder has been removed successfully from [ $PokemonTCGConfPath ]"
            }
            else {
                Write-Error "The PokemonTCG configuration folder could not be removed from [ $PokemonTCGConfPath ]"
            }

        }
        else {
            Write-Warning "No configuration folder found at [ $PokemonTCGConfPath ]"
        }

    }

    end {}

}
#EndRegion '.\Private\moduleSettings\Remove-PokemonTCGModuleSettings.ps1' 87
#Region '.\Public\cards\Get-PokemonTCGCard.ps1' -1

function Get-PokemonTCGCard {
<#
    .SYNOPSIS
        Gets PokemonTCG cards

    .DESCRIPTION
        The Get-PokemonTCGCard cmdlet gets PokemonTCG cards individually, in bulk,
        & or with advanced query filters (Filters are case-sensitive)

        Details on allowed queries can be found at
        https://docs.pokemontcg.io/api-reference/cards/card-object

    .PARAMETER id
        The id of the card

    .PARAMETER select
        A comma delimited list of fields to return in the response

        By default, all fields are returned if not defined

    .PARAMETER q
        The search query

    .PARAMETER orderBy
        The field(s) to order the results by

    .PARAMETER page
        Defines the page number to return

    .PARAMETER pageSize
        Defines the amount of items to return with each page

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use the page parameter

    .EXAMPLE
        Get-PokemonTCGCard

        Gets the first 250 PokemonTCG cards

    .EXAMPLE
        Get-PokemonTCGCard -id base3-3

        Returns the PokemonTCG ditto object with the defined id

    .EXAMPLE
        'base3-3' | Get-PokemonTCGCard

        Returns the PokemonTCG ditto object with the defined id

    .EXAMPLE
        Get-PokemonTCGCard -q 'name:ditto'

        Returns the first 250 ditto's from the PokemonTCG API

    .EXAMPLE
        Get-PokemonTCGCard -q 'nationalPokedexNumbers:132'

        Returns the first 250 ditto's from the PokemonTCG API

    .EXAMPLE
        Get-PokemonTCGCard -q 'set.id:base*' -Verbose

        Returns the first 250 pokemon from any base set starting with the
        defined term from the PokemonTCG API

        Progress information is sent to the console while the cmdlet is running

    .EXAMPLE
        Get-PokemonTCGCard -q 'set.id:base* types:water' -Verbose

        Returns the first 250 water type pokemon from any base set starting with the
        defined term from the PokemonTCG API

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        The PokemonTCG card object contains the following attributes: (https://docs.pokemontcg.io/api-reference/cards/card-object#attributes)
            id string
            name string
            supertype string
            subtypes list(string)
            level string
            hp string
            types list(string)
            evolvesFrom string
            evolvesTo list(string)
            rules list(string)
            ancientTrait hash
            abilities list(hash)
            attacks list(hash)
            weaknesses list(hash)
            resistances list(hash)
            retreatCost list(string)
            convertedRetreatCost integer
            set hash
            number string
            artist string
            rarity string
            flavorText string
            nationalPokedexNumbers list(integer)
            legalities hash
            regulationMark string
            images hash
            tcgplayer hash
            cardmarket hash

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/cards/Get-PokemonTCGCard.html

    .Link
        https://docs.pokemontcg.io/api-reference/cards/card-object#attributes
#>

    [CmdletBinding(DefaultParameterSetName = 'Show')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Index', ValueFromPipeline = $true)]
        [string]$id,

        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$select,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [Alias('query')]
        [string]$q,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$orderBy,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, 250)]
        [int64]$pageSize,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [switch]$allPages
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $resourceURI = "/cards/$id" }
            'Show'  { $resourceURI = "/cards" }
        }

        #Region     [ Parameter Adjustments ]

        if ($PSCmdlet.ParameterSetName -eq 'Show') {

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters.page = 1 }
            else { $PSBoundParameters.page = $Page }

            if( -not $PSBoundParameters.ContainsKey('pageSize') ) { $PSBoundParameters.pageSize = 250 }
            else { $PSBoundParameters.pageSize = $PageSize }
        }

        #EndRegion  [ Parameter Adjustments ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\cards\Get-PokemonTCGCard.ps1' 186
#Region '.\Public\rarities\Get-PokemonTCGRarity.ps1' -1

function Get-PokemonTCGRarity {
<#
    .SYNOPSIS
        Gets PokemonTCG rarities

    .DESCRIPTION
        The Get-PokemonTCGRarity cmdlet gets PokemonTCG rarities

    .EXAMPLE
        Get-PokemonTCGRarity

        Gets the first 250 PokemonTCG rarities

    .EXAMPLE
        Get-PokemonTCGRarity -Verbose

        Gets the first 250 PokemonTCG rarities

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/rarities/Get-PokemonTCGRarity.html

    .Link
        https://docs.pokemontcg.io/api-reference/rarities/get-rarities
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $resourceURI = "/rarities"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\rarities\Get-PokemonTCGRarity.ps1' 58
#Region '.\Public\sets\Get-PokemonTCGSet.ps1' -1

function Get-PokemonTCGSet {
<#
    .SYNOPSIS
        Gets PokemonTCG sets

    .DESCRIPTION
        The Get-PokemonTCGSet cmdlet gets PokemonTCG sets individually, in bulk,
        & or with advanced query filters (Filters are case-sensitive)

        Details on allowed queries can be found at
        https://docs.pokemontcg.io/api-reference/sets/set-object#attributes

    .PARAMETER id
        The id of the set

    .PARAMETER select
        A comma delimited list of fields to return in the response

        By default, all fields are returned if not defined

    .PARAMETER q
        The search query

    .PARAMETER orderBy
        The field(s) to order the results by

    .PARAMETER page
        Defines the page number to return

    .PARAMETER pageSize
        Defines the amount of items to return with each page

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use the page parameter

    .EXAMPLE
        Get-PokemonTCGSet

        Gets the first 250 PokemonTCG sets

    .EXAMPLE
        Get-PokemonTCGSet -id base1

        Returns the set with the defined id

    .EXAMPLE
        'base1' | Get-PokemonTCGSet

        Returns the set with the defined id

    .EXAMPLE
        Get-PokemonTCGSet -q 'series:base'

        Returns the first 250 sets with the defined series

    .EXAMPLE
        Get-PokemonTCGSet -q 'name:base*' -Verbose

        Returns the first 250 sets that start with the defined name

        Progress information is sent to the console while the cmdlet is running

    .EXAMPLE
        Get-PokemonTCGSet -q 'series:base printedTotal:[* TO 102]' -Verbose

        Returns the first 250 sets from the defined series that contain up to 102 printed cards

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        The PokemonTCG sets object contains the following attributes: (https://docs.pokemontcg.io/api-reference/sets/set-object#attributes)
        id string
        name string
        series string
        printedTotal integer
        total integer
        legalities hash
        ptcgoCode string
        releaseDate string
        updatedAt string
        images hash

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/sets/Get-PokemonTCGSet.html

    .Link
        https://docs.pokemontcg.io/api-reference/sets/set-object#attributes
#>

    [CmdletBinding(DefaultParameterSetName = 'Show')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Index', ValueFromPipeline = $true)]
        [string]$id,

        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$select,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [Alias('query')]
        [string]$q,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$orderBy,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, 250)]
        [int64]$pageSize,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [switch]$allPages
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $resourceURI = "/sets/$id" }
            'Show'  { $resourceURI = "/sets" }
        }

        #Region     [ Parameter Adjustments ]

        if ($PSCmdlet.ParameterSetName -eq 'Show') {

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters.page = 1 }
            else { $PSBoundParameters.page = $Page }

            if( -not $PSBoundParameters.ContainsKey('pageSize') ) { $PSBoundParameters.pageSize = 250 }
            else { $PSBoundParameters.pageSize = $PageSize }
        }

        #EndRegion  [ Parameter Adjustments ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\sets\Get-PokemonTCGSet.ps1' 161
#Region '.\Public\subtypes\Get-PokemonTCGSubtype.ps1' -1

function Get-PokemonTCGSubtype {
<#
    .SYNOPSIS
        Gets PokemonTCG Subtypes

    .DESCRIPTION
        The Get-PokemonTCGSubtype cmdlet gets PokemonTCG Subtypes

    .EXAMPLE
        Get-PokemonTCGSubtype

        Gets the first 250 PokemonTCG Subtypes

    .EXAMPLE
        Get-PokemonTCGSubtype -Verbose

        Gets the first 250 PokemonTCG Subtypes

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Subtypes/Get-PokemonTCGSubtype.html

    .Link
        https://docs.pokemontcg.io/api-reference/subtypes/get-subtypes
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $resourceURI = "/subtypes"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\subtypes\Get-PokemonTCGSubtype.ps1' 58
#Region '.\Public\supertypes\Get-PokemonTCGSupertype.ps1' -1

function Get-PokemonTCGSupertype {
<#
    .SYNOPSIS
        Gets PokemonTCG Supertypes

    .DESCRIPTION
        The Get-PokemonTCGSupertype cmdlet gets PokemonTCG Supertypes

    .EXAMPLE
        Get-PokemonTCGSupertype

        Gets the first 250 PokemonTCG Supertypes

    .EXAMPLE
        Get-PokemonTCGSupertype -Verbose

        Gets the first 250 PokemonTCG Supertypes

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Supertypes/Get-PokemonTCGSupertype.html

    .Link
        https://docs.pokemontcg.io/api-reference/supertypes/get-supertypes
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $resourceURI = "/supertypes"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\supertypes\Get-PokemonTCGSupertype.ps1' 58
#Region '.\Public\types\Get-PokemonTCGType.ps1' -1

function Get-PokemonTCGType {
<#
    .SYNOPSIS
        Gets PokemonTCG types

    .DESCRIPTION
        The Get-PokemonTCGType cmdlet gets PokemonTCG types

    .EXAMPLE
        Get-PokemonTCGType

        Gets the first 250 PokemonTCG types

    .EXAMPLE
        Get-PokemonTCGType -Verbose

        Gets the first 250 PokemonTCG types

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/types/Get-PokemonTCGType.html

    .Link
        https://docs.pokemontcg.io/api-reference/types/get-types
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $resourceURI = "/types"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
#EndRegion '.\Public\types\Get-PokemonTCGType.ps1' 58
