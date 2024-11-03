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