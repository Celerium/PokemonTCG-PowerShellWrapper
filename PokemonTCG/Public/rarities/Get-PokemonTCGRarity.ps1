function Get-PokemonTCGRarity {
<#
    .SYNOPSIS
        Gets PokemonTCG rarities

    .DESCRIPTION
        The Get-PokemonTCGRarity cmdlet gets PokemonTCG rarities

    .EXAMPLE
        Get-PokemonTCGRarity

        Gets the first 250 PokemonTCG rarities

    .EXAMPLE
        Get-PokemonTCGRarity -Verbose

        Gets the first 250 PokemonTCG rarities

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Rarities/Get-PokemonTCGRarity.html

    .Link
        https://docs.pokemontcg.io/api-reference/rarities/get-rarities
#>

    [CmdletBinding(DefaultParameterSetName = 'Index')]
    Param ()

    begin {

        $FunctionName       = $MyInvocation.InvocationName
        $ParameterName      = $functionName + '_Parameters'      -replace '-','_'
        $QueryParameterName = $functionName + '_ParametersQuery' -replace '-','_'

    }

    process {

        Write-Verbose "[ $FunctionName ] - Running the [ $($PSCmdlet.ParameterSetName) ] parameterSet"

        $resourceURI = "/rarities"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
