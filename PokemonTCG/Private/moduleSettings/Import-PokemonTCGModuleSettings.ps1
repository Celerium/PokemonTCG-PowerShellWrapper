function Import-PokemonTCGModuleSettings {
<#
    .SYNOPSIS
        Imports the PokemonTCG BaseURI, API, & JSON configuration information to the current session

    .DESCRIPTION
        The Import-PokemonTCGModuleSettings cmdlet imports the PokemonTCG BaseURI, API, & JSON configuration
        information stored in the PokemonTCG configuration file to the users current session

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

    .EXAMPLE
        Import-PokemonTCGModuleSettings

        Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The default location of the PokemonTCG configuration file is:
            $env:USERPROFILE\PokemonTCG\config.psd1

    .EXAMPLE
        Import-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1

        Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
        then imports the stored data into the current users session

        The location of the PokemonTCG configuration file in this example is:
            C:\PokemonTCG\MyConfig.psd1

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Import-PokemonTCGModuleSettings.html
#>

    [CmdletBinding(DefaultParameterSetName = 'set')]
    Param (
        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfPath = $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) ),

        [Parameter(ParameterSetName = 'set')]
        [string]$PokemonTCGConfFile = 'config.psd1'
    )

    begin {
        $PokemonTCGConfig = Join-Path -Path $PokemonTCGConfPath -ChildPath $PokemonTCGConfFile
    }

    process {

        if ( Test-Path $PokemonTCGConfig ) {
            $tmp_config = Import-LocalizedData -BaseDirectory $PokemonTCGConfPath -FileName $PokemonTCGConfFile

            # Send to function to strip potentially superfluous slash (/)
            Add-PokemonTCGBaseURI $tmp_config.PokemonTCG_BaseURI

            $tmp_config.PokemonTCG_API_Key = ConvertTo-SecureString $tmp_config.PokemonTCG_API_Key

            Set-Variable -Name "PokemonTCG_API_Key" -Value $tmp_config.PokemonTCG_API_Key -Option ReadOnly -Scope Global -Force

            Set-Variable -Name "PokemonTCG_JSON_Conversion_Depth" -Value $tmp_config.PokemonTCG_JSON_Conversion_Depth -Scope Global -Force

            Write-Verbose "PokemonTCG Module configuration loaded successfully from [ $PokemonTCGConfig ]"

            # Clean things up
            Remove-Variable "tmp_config"
        }
        else {
            Write-Verbose "No configuration file found at [ $PokemonTCGConfig ] run Add-PokemonTCGApiKey to get started."

            Add-PokemonTCGBaseURI

            Set-Variable -Name "PokemonTCG_BaseURI" -Value $(Get-PokemonTCGBaseURI) -Option ReadOnly -Scope Global -Force
            Set-Variable -Name "PokemonTCG_JSON_Conversion_Depth" -Value 100 -Scope Global -Force
        }

    }

    end {}

}