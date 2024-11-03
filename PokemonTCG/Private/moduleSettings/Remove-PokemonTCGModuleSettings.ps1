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