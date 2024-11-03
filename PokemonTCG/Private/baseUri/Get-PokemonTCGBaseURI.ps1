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