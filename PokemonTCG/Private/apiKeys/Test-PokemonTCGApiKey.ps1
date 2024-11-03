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
