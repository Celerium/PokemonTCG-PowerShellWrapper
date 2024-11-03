function Export-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Exports the PokemonTCG BaseURI, API, & JSON configuration information to file

    .DESCRIPTION
        The Export-PokemonTCGModuleSettings cmdlet exports the PokemonTCG BaseURI, API, & JSON configuration information to file

        Making use of PowerShell's System.Security.SecureString type, exporting module settings encrypts your API key in a format
        that can only be unencrypted with the your Windows account as this encryption is tied to your user principal
        This means that you cannot copy your configuration file to another computer or user account and expect it to work

    .PARAMETER PokemonTCGConfPath
        Define the location to store the PokemonTCG configuration file

        By default the configuration file is stored in the following location:
            $env:USERPROFILE\PokemonTCG

    .PARAMETER PokemonTCGConfFile
        Define the name of the PokemonTCG configuration file

        By default the configuration file is named:
            config.psd1

    .EXAMPLE
        Export-PokemonTCGModuleSettings

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's PokemonTCG configuration file located at:
            $env:USERPROFILE\PokemonTCG\config.psd1

    .EXAMPLE
        Export-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1

        Validates that the BaseURI, API, and JSON depth are set then exports their values
        to the current user's PokemonTCG configuration file located at:
            C:\PokemonTCG\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Export-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfFile = 'config.psd1'
    )

    begin {}

    process {

        Write-Warning "Secrets are stored using Windows Data Protection API (DPAPI)"
        Write-Warning "DPAPI provides user context encryption in Windows but NOT in other operating systems like Linux or UNIX. It is recommended to use a more secure & cross-platform storage method"

        $PokemonTCGConfig = Join-Path -Path $PokemonTCGConfPath -ChildPath $PokemonTCGConfFile

        # Confirm variables exist and are not null before exporting
        if ($PokemonTCG_BaseURI -and $PokemonTCG_API_Key -and $PokemonTCG_JSON_Conversion_Depth) {
            $secureString = $PokemonTCG_API_Key | ConvertFrom-SecureString

            if ($IsWindows -or $PSEdition -eq 'Desktop') {
                New-Item -Path $PokemonTCGConfPath -ItemType Directory -Force | ForEach-Object { $_.Attributes = $_.Attributes -bor "Hidden" }
            }
            else{
                New-Item -Path $PokemonTCGConfPath -ItemType Directory -Force
            }
@"
    @{
        PokemonTCG_BaseURI = '$PokemonTCG_BaseURI'
        PokemonTCG_API_Key = '$secureString'
        PokemonTCG_JSON_Conversion_Depth = '$PokemonTCG_JSON_Conversion_Depth'
    }
"@ | Out-File -FilePath $PokemonTCGConfig -Force
        }
        else {
            Write-Error "Failed to export PokemonTCG Module settings to [ $PokemonTCGConfig ]"
            Write-Error $_
            exit 1
        }

    }

    end {}

}