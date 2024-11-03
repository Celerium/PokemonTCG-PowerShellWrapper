<#
    .SYNOPSIS
        Gets one or more PokemonTCG cards at random

    .DESCRIPTION
        The Get-PokemonTCGRandomCard script gets one or more PokemonTCG cards at random

    .PARAMETER ApiKey
        PokemonTCG API key

    .PARAMETER APIUri
        Define what PokemonTCG endpoint to connect to

        The default is https://api.pokemontcg.io/v2

    .PARAMETER Count
        The number of random objects to return

    .EXAMPLE
        Get-PokemonTCGRandomCard

        Gets a 5 random cards and data is returned to the console

    .EXAMPLE
        Get-PokemonTCGRandomCard -ApiKey 12345 -Count 3

        Gets a 3 random cards and data is returned to the console

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
        [string]$APIUri,

        [Parameter()]
        [ValidateRange(1, 5)]
        [int]$Count = 5

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

    $tcgSets        = (Get-PokemonTCGSet -select 'id,name,series').data | Get-Random -Count 1
    $tcgTypes       = (Get-PokemonTCGType).data | Get-Random -Count 1

    switch ('sets','types' | Get-Random -Count 1){
        'sets'  {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Getting [ $Count ] pokemon filter by the set of [ $($tcgSets.id) ]"
            $tcgCards = (Get-PokemonTCGCard -q "set.id:$($tcgSets.id)").data | Get-Random -Count $Count}
        'types' {
            Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Getting [ $Count ] pokemon filter by the type of [ $tcgTypes ]"
            $tcgCards = (Get-PokemonTCGCard -q "types:$tcgTypes").data | Get-Random -Count $Count}
    }

    $ExampleReturnData = $tcgCards

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