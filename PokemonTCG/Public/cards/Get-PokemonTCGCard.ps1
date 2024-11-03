function Get-PokemonTCGCard {
<#
    .SYNOPSIS
        Gets PokemonTCG cards

    .DESCRIPTION
        The Get-PokemonTCGCard cmdlet gets PokemonTCG cards individually, in bulk,
        & or with advanced query filters (Filters are case-sensitive)

        Details on allowed queries can be found at
        https://docs.pokemontcg.io/api-reference/cards/card-object

    .PARAMETER id
        The id of the card

    .PARAMETER select
        A comma delimited list of fields to return in the response

        By default, all fields are returned if not defined

    .PARAMETER q
        The search query

    .PARAMETER orderBy
        The field(s) to order the results by

    .PARAMETER page
        Defines the page number to return

    .PARAMETER pageSize
        Defines the amount of items to return with each page

    .PARAMETER allPages
        Returns all items from an endpoint

        When using this parameter there is no need to use the page parameter

    .EXAMPLE
        Get-PokemonTCGCard

        Gets the first 250 PokemonTCG cards

    .EXAMPLE
        Get-PokemonTCGCard -id base3-3

        Returns the PokemonTCG ditto object with the defined id

    .EXAMPLE
        'base3-3' | Get-PokemonTCGCard

        Returns the PokemonTCG ditto object with the defined id

    .EXAMPLE
        Get-PokemonTCGCard -q 'name:ditto'

        Returns the first 250 ditto's from the PokemonTCG API

    .EXAMPLE
        Get-PokemonTCGCard -q 'nationalPokedexNumbers:132'

        Returns the first 250 ditto's from the PokemonTCG API

    .EXAMPLE
        Get-PokemonTCGCard -q 'set.id:base*' -Verbose

        Returns the first 250 pokemon from any base set starting with the
        defined term from the PokemonTCG API

        Progress information is sent to the console while the cmdlet is running

    .EXAMPLE
        Get-PokemonTCGCard -q 'set.id:base* types:water' -Verbose

        Returns the first 250 water type pokemon from any base set starting with the
        defined term from the PokemonTCG API

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        The PokemonTCG card object contains the following attributes: (https://docs.pokemontcg.io/api-reference/cards/card-object#attributes)
            id string
            name string
            supertype string
            subtypes list(string)
            level string
            hp string
            types list(string)
            evolvesFrom string
            evolvesTo list(string)
            rules list(string)
            ancientTrait hash
            abilities list(hash)
            attacks list(hash)
            weaknesses list(hash)
            resistances list(hash)
            retreatCost list(string)
            convertedRetreatCost integer
            set hash
            number string
            artist string
            rarity string
            flavorText string
            nationalPokedexNumbers list(integer)
            legalities hash
            regulationMark string
            images hash
            tcgplayer hash
            cardmarket hash

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/cards/Get-PokemonTCGCard.html

    .Link
        https://docs.pokemontcg.io/api-reference/cards/card-object#attributes
#>

    [CmdletBinding(DefaultParameterSetName = 'Show')]
    Param (
        [Parameter(Mandatory = $true, ParameterSetName = 'Index', ValueFromPipeline = $true)]
        [string]$id,

        [Parameter(Mandatory = $false, ParameterSetName = 'Index')]
        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$select,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [Alias('query')]
        [string]$q,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [string]$orderBy,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, [int64]::MaxValue)]
        [int64]$page,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [ValidateRange(1, 250)]
        [int64]$pageSize,

        [Parameter(Mandatory = $false, ParameterSetName = 'Show')]
        [switch]$allPages
    )

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        switch ($PSCmdlet.ParameterSetName) {
            'Index' { $resourceURI = "/cards/$id" }
            'Show'  { $resourceURI = "/cards" }
        }

        #Region     [ Parameter Adjustments ]

        if ($PSCmdlet.ParameterSetName -eq 'Show') {

            #Add default PSBoundParameters
            if( -not $PSBoundParameters.ContainsKey('page') ) { $PSBoundParameters.page = 1 }
            else { $PSBoundParameters.page = $Page }

            if( -not $PSBoundParameters.ContainsKey('pageSize') ) { $PSBoundParameters.pageSize = 250 }
            else { $PSBoundParameters.pageSize = $PageSize }
        }

        #EndRegion  [ Parameter Adjustments ]

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
