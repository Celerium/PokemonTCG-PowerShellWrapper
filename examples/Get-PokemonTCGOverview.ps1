<#
    .SYNOPSIS
        Gets an overview of the PokemonTCG API

    .DESCRIPTION
        The Get-PokemonTCGOverview script gets an overview of the resources available
        with the PokemonTCG API

    .PARAMETER ApiKey
        PokemonTCG API key

    .PARAMETER APIUri
        Define what PokemonTCG endpoint to connect to

        The default is https://api.pokemontcg.io/v2

    .EXAMPLE
        Get-PokemonTCGOverview

        Gets an overview of the PokemonTCG API and data is returned to the console

    .EXAMPLE
        Get-PokemonTCGOverview -ApiKey 12345

        Gets an overview of the PokemonTCG API and data is returned to the console

    .NOTES
        N/A

    .LINK
        https://celerium.org/

    .LINK
        https://github.com/Celerium/PokemonTCG-PowerShellWrapper
#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 3.0

#Region     [ Parameters ]

    [CmdletBinding()]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$APIKey,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$APIUri

    )

#EndRegion  [ Parameters ]

    Write-Verbose ''
    Write-Verbose "START - $(Get-Date -Format yyyy-MM-dd-HH:mm) - Using the [ $($PSCmdlet.ParameterSetName) ] parameterSet"
    Write-Verbose ''
    Write-Verbose " - (0/2) - $(Get-Date -Format MM-dd-HH:mm) - Setting up prerequisites"

#Region     [ Prerequisites ]

    $FunctionName   = $MyInvocation.MyCommand.Name -replace '.ps1' -replace '-','_'
    $StepNumber     = 1

    Import-Module PokemonTCG -Verbose:$false -ErrorAction SilentlyContinue

    #Setting up PokemonTCG APIKey & BaseURI
    try {

        if ($APIKey) { Add-PokemonTCGKey $APIKey }

        if ($APIUri) { Add-PokemonTCGBaseURI -BaseUri $APIUri }
        if([bool]$(Get-PokemonTCGBaseURI -WarningAction SilentlyContinue) -eq $false) {
            Add-PokemonTCGBaseURI
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Using [ $(Get-PokemonTCGBaseURI) ]"
        }

    }
    catch {
        Write-Error $_
        exit 1
    }


#EndRegion  [ Prerequisites ]

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Finding PokemonTCG data"
    $StepNumber++

#Region     [ Main Code ]

try {

    $tcgCards       = Get-PokemonTCGCard
    $tcgSets        = Get-PokemonTCGSet
    $tcgTypes       = Get-PokemonTCGType
    $tcgSubtypes    = Get-PokemonTCGSubtype
    $tcgSupertypes  = Get-PokemonTCGSupertype
    $tcgRarities    = Get-PokemonTCGRarity

    $ExampleReturnData = [PSCustomObject]@{
        tcgCardCount        = $tcgCards.totalCount
        tcgCardSets         = $tcgSets.totalCount
        tcgCardTypes        = ($tcgTypes.data | Measure-Object).Count
        tcgCardSubtypes     = ($tcgSubtypes.data | Measure-Object).Count
        tcgCardSupertypes   = ($tcgSupertypes.data | Measure-Object).Count
        tcgCardRarities     = ($tcgRarities.data | Measure-Object).Count
    }

    #Helpful global troubleshooting variable
    Set-Variable -Name "$($FunctionName)_Return" -Value $ExampleReturnData -Scope Global -Force

    $ExampleReturnData

}
catch {
    Write-Error $_
    exit 1
}

#EndRegion  [ Main Code ]

Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Done"

Write-Verbose ''
Write-Verbose "END - $(Get-Date -Format yyyy-MM-dd-HH:mm)"
Write-Verbose ''