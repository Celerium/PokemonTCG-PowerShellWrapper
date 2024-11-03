function Get-PokemonTCGSubtype {
<#
    .SYNOPSIS
        Gets PokemonTCG Subtypes

    .DESCRIPTION
        The Get-PokemonTCGSubtype cmdlet gets PokemonTCG Subtypes

    .EXAMPLE
        Get-PokemonTCGSubtype

        Gets the first 250 PokemonTCG Subtypes

    .EXAMPLE
        Get-PokemonTCGSubtype -Verbose

        Gets the first 250 PokemonTCG Subtypes

        Progress information is sent to the console while the cmdlet is running

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Subtypes/Get-PokemonTCGSubtype.html

    .Link
        https://docs.pokemontcg.io/api-reference/subtypes/get-subtypes
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

        $resourceURI = "/subtypes"

        Set-Variable -Name $ParameterName -Value $PSBoundParameters -Scope Global -Force -Confirm:$false
        Set-Variable -Name $QueryParameterName -Value $query_params -Scope Global -Force -Confirm:$false

        return Invoke-PokemonTCGRequest -method GET -resourceURI $resourceURI -uriFilter $PSBoundParameters -allPages:$allPages

    }

    end {}

}
