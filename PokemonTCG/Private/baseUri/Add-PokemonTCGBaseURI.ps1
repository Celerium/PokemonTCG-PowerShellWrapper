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