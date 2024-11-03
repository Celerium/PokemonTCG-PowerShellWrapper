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
