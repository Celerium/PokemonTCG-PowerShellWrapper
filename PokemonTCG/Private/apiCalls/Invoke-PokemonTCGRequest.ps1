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