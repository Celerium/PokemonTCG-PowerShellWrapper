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