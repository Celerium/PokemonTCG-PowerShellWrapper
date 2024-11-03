<#
    .SYNOPSIS
        Downloads one or more PokemonTCG card images

    .DESCRIPTION
        The Download-PokemonTCGCardImage script downloads one or more PokemonTCG card images

    .PARAMETER ApiKey
        PokemonTCG API key

    .PARAMETER APIUri
        Define what PokemonTCG endpoint to connect to

        The default is https://api.pokemontcg.io/v2

    .PARAMETER imageSize
        The image resolution type to download

        By default the small images are downloaded

        Allowed values:
            'small','large'

    .PARAMETER imageNamePreSet
        Set a custom image name instead of the default file name

    .PARAMETER outputFolder
        The folder to output the downloaded files into

        By default all downloads are place in $PSScriptRoot/Images

    .EXAMPLE
        Download-PokemonTCGCardImage -id 'base1-1'

        Downloads the small image for the defined card id. Card image names match the source

    .EXAMPLE
        Download-PokemonTCGCardImage -id 'base1-1' -imageSize large -imageNamePreSet -Verbose

        Downloads the large image for the defined card id. Card name will be customized with
        a pre-determined value and progress information is written to the console as the
        script runs.

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
        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$APIKey,

        [Parameter(Mandatory = $false)]
        [ValidateNotNullOrEmpty()]
        [string]$APIUri,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true )]
        [string]$id,

        [Parameter(Mandatory = $false)]
        [ValidateSet('small','large')]
        [string]$imageSize = 'small',

        [Parameter(Mandatory = $false)]
        [switch]$imageNamePreSet,

        [Parameter(Mandatory = $false)]
        [string]$outputFolder

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

        if ($APIKey -or [bool](Get-PokemonTCGApiKey -plainText) -eq $true) {

            if ([bool]$APIKey -eq $true) {
                Add-PokemonTCGApiKey $APIKey
            }

            $UsingApiKey    = $true
            $Base64ApiKey   = [Convert]::ToBase64String( [Text.Encoding]::ASCII.GetBytes( $(Get-PokemonTCGApiKey -plainTex)) )

        }
        else{
            $UsingApiKey    = $false
            Write-Warning " -       - $(Get-Date -Format MM-dd-HH:mm) - Without an API key you will be rate limited to 1000 requests a day, and a maximum of 30 per minute."
        }

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

    switch ([bool]$outputFolder) {
        $true   { $FolderPath = $outputFolder }
        $false  { $FolderPath = $PSScriptRoot }
    }

    #Setting up image folder
    $rootPath = Join-Path -Path $FolderPath -ChildPath Images
    if ((Test-Path $rootPath) -eq $false ) {
        New-Item -Path $rootPath -ItemType Directory > $null
    }

#EndRegion  [ Prerequisites ]

    Write-Verbose " - ($StepNumber/2) - $(Get-Date -Format MM-dd-HH:mm) - Finding PokemonTCG data"
    $StepNumber++

#Region     [ Main Code ]

try {

    $tcgCard = (Get-PokemonTCGCard -id $id -select 'id,name,set,nationalPokedexNumbers,number,rarity,images' -ErrorAction Stop).data

    if ($tcgCard) {

        switch ($imageNamePreSet) {
            $true   {

                Write-Verbose " -       - $(Get-Date -Format MM-dd-HH:mm) - Downloading PokemonTCG Card - [ $($tcgCard.name) | $($tcgCard.name -replace '[\u00C3]','e' -replace '[^0-9a-zA-Z._\- ]','') | $($tcgCard.id) ]"

                $CardName               = $tcgCard.name
                $CardSeries             = $tcgCard.set.series
                $CardSeriesName         = $tcgCard.set.name
                $CardPokedexNumber      = if($tcgCard.nationalPokedexNumbers){$tcgCard.nationalPokedexNumbers}else{'000'}
                $CardNumber             = $tcgCard.number
                $CardRarity             = if($tcgCard.rarity){$tcgCard.rarity}else{'000'}
                $CardReleaseDate        = ([DateTime]$tcgCard.set.releaseDate).ToString('yyyy-MM-dd')
                $CardImageResolution    = $imageSize
                $CardFileExtension      = [IO.Path]::GetExtension( $($tcgCard.images.$imageSize | Split-Path -Leaf) )

                $Name = "$CardName-$CardSeries-$CardSeriesName-$CardPokedexNumber-$CardNumber-$CardRarity-$CardReleaseDate-$CardImageResolution$CardFileExtension"
                $Name = $Name -replace '[\u00C3]','e' -replace '[^0-9a-zA-Z._\- ]',''

                $Destination = Join-Path -Path $rootPath -ChildPath $Name
            }
            $false  { $Destination = $rootPath }
        }

        switch ($UsingApiKey) {
            $true   { Start-BitsTransfer -CustomHeaders "X-Api-Key: $Base64ApiKey" -Source $tcgCard.images.$imageSize -Destination $Destination}
            $false  { Start-BitsTransfer -Source $tcgCard.images.$imageSize -Destination $Destination}
        }

    }

    $ExampleReturnData = $tcgCard

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