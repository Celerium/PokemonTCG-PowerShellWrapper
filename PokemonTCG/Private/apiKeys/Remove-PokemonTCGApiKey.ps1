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