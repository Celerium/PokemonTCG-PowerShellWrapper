function Get-PokemonTCGType {
<#
    .SYNOPSIS
        Gets PokemonTCG types

    .DESCRIPTION
        The Get-PokemonTCGType cmdlet gets PokemonTCG types

    .EXAMPLE
        Get-PokemonTCGType

        Gets the first 250 PokemonTCG types

    .EXAMPLE
        Get-PokemonTCGType -Verbose

        Gets the first 250 PokemonTCG types

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/types/Get-PokemonTCGType.html

    .Link
        https://docs.pokemontcg.io/api-reference/types/get-types
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

        $resourceURI = "/types"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
