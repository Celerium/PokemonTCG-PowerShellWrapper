function ConvertTo-PokemonTCGQueryString {
<#
    .SYNOPSIS
        Converts uri filter parameters

    .DESCRIPTION
        The Invoke-PokemonTCGRequest cmdlet converts & formats uri filter parameters
        from a function which are later used to make the full resource uri for
        an API call

        This is an internal helper function the ties in directly with the
        Invoke-PokemonTCGRequest & any public functions that define parameters

    .PARAMETER uriFilter
        Hashtable of values to combine a functions parameters with
        the resourceURI parameter

        This allows for the full uri query to occur

    .PARAMETER resourceURI
        Defines the short resource uri (url) to use when creating the API call

    .EXAMPLE
        ConvertTo-PokemonTCGQueryString -uriFilter $uriFilter -resourceURI '/cards'

        Example: (From public function)
            $uriFilter = @{}

            ForEach ( $Key in $PSBoundParameters.GetEnumerator() ) {
                if( $excludedParameters -contains $Key.Key ) {$null}
                else{ $uriFilter += @{ $Key.Key = $Key.Value } }
            }

            1x key = https://api.pokemontcg.io/v2/cards?q=name:ditto'
            2x key = https://api.pokemontcg.io/v2/cards?q=types:water&select=id,name'

    .NOTES
        N/A

    .LINK
        https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/ConvertTo-PokemonTCGQueryString.html

#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$resourceURI,

    [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
    [hashtable]$uriFilter
)

    begin {}

    process {

        if (-not $uriFilter) {
            return ""
        }

        $excludedParameters =   'Debug', 'ErrorAction', 'ErrorVariable', 'InformationAction', 'InformationVariable',
                                'OutBuffer', 'OutVariable', 'PipelineVariable', 'Verbose', 'WarningAction', 'WarningVariable',
                                'allPages','id'

        $query_Parameters = [System.Web.HttpUtility]::ParseQueryString([string]::Empty)

        ForEach ( $Key in $uriFilter.GetEnumerator() ) {

            if( $excludedParameters -contains $Key.Key ) {$null}
            elseif ( $Key.Value.GetType().IsArray ) {
                Write-Verbose "[ $($Key.Key) ] is an array parameter"
                foreach ($Value in $Key.Value) {
                    $query_Parameters.Add($Key.Key, $Value)
                }
            }
            else{
                $query_Parameters.Add($Key.Key, $Key.Value)
            }

        }

        # Build the request and load it with the query string
        $uri_Request        = [System.UriBuilder]($PokemonTCG_BaseURI + $resourceURI)
        $uri_Request.Query  = $query_Parameters.ToString()

        return $uri_Request

    }

    end {}

}