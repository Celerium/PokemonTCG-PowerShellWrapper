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
