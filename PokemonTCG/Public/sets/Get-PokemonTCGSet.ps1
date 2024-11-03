function Get-PokemonTCGSet {
<#
    .SYNOPSIS
        Gets PokemonTCG sets

    .DESCRIPTION
        The Get-PokemonTCGSet cmdlet gets PokemonTCG sets individually, in bulk,
        & or with advanced query filters (Filters are case-sensitive)

        Details on allowed queries can be found at
        https://docs.pokemontcg.io/api-reference/sets/set-object#attributes

    .PARAMETER id
        The id of the set

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
        Get-PokemonTCGSet

        Gets the first 250 PokemonTCG sets

    .EXAMPLE
        Get-PokemonTCGSet -id base1

        Returns the set with the defined id

    .EXAMPLE
        'base1' | Get-PokemonTCGSet

        Returns the set with the defined id

    .EXAMPLE
        Get-PokemonTCGSet -q 'series:base'

        Returns the first 250 sets with the defined series

    .EXAMPLE
        Get-PokemonTCGSet -q 'name:base*' -Verbose

        Returns the first 250 sets that start with the defined name

        Progress information is sent to the console while the cmdlet is running

    .EXAMPLE
        Get-PokemonTCGSet -q 'series:base printedTotal:[* TO 102]' -Verbose

        Returns the first 250 sets from the defined series that contain up to 102 printed cards

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        The PokemonTCG sets object contains the following attributes: (https://docs.pokemontcg.io/api-reference/sets/set-object#attributes)
        id string
        name string
        series string
        printedTotal integer
        total integer
        legalities hash
        ptcgoCode string
        releaseDate string
        updatedAt string
        images hash

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/sets/Get-PokemonTCGSet.html

    .Link
        https://docs.pokemontcg.io/api-reference/sets/set-object#attributes
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
            'Index' { $resourceURI = "/sets/$id" }
            'Show'  { $resourceURI = "/sets" }
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
