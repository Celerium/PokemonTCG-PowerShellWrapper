function Get-PokemonTCGSupertype {
<#
    .SYNOPSIS
        Gets PokemonTCG Supertypes

    .DESCRIPTION
        The Get-PokemonTCGSupertype cmdlet gets PokemonTCG Supertypes

    .EXAMPLE
        Get-PokemonTCGSupertype

        Gets the first 250 PokemonTCG Supertypes

    .EXAMPLE
        Get-PokemonTCGSupertype -Verbose

        Gets the first 250 PokemonTCG Supertypes

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Supertypes/Get-PokemonTCGSupertype.html

    .Link
        https://docs.pokemontcg.io/api-reference/supertypes/get-supertypes
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

        $resourceURI = "/supertypes"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
