---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/ConvertTo-PokemonTCGQueryString.html
parent: PUT
schema: 2.0.0
title: ConvertTo-PokemonTCGQueryString
---

# ConvertTo-PokemonTCGQueryString

## SYNOPSIS
Converts uri filter parameters

## SYNTAX

```powershell
ConvertTo-PokemonTCGQueryString [-resourceURI] <String> [-uriFilter] <Hashtable> [<CommonParameters>]
```

## DESCRIPTION
The Invoke-PokemonTCGRequest cmdlet converts & formats uri filter parameters
from a function which are later used to make the full resource uri for
an API call

This is an internal helper function the ties in directly with the
Invoke-PokemonTCGRequest & any public functions that define parameters

## EXAMPLES

### EXAMPLE 1
```powershell
ConvertTo-PokemonTCGQueryString -uriFilter $uriFilter -resourceURI '/cards'
```

Example: (From public function)
    $uriFilter = @{}

    ForEach ( $Key in $PSBoundParameters.GetEnumerator() ) {
        if( $excludedParameters -contains $Key.Key ) {$null}
        else{ $uriFilter += @{ $Key.Key = $Key.Value } }
    }

    1x key = https://api.pokemontcg.io/v2/cards?q=name:ditto'
    2x key = https://api.pokemontcg.io/v2/cards?q=types:water&select=id,name'

## PARAMETERS

### -resourceURI
Defines the short resource uri (url) to use when creating the API call

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uriFilter
Hashtable of values to combine a functions parameters with
the resourceURI parameter

This allows for the full uri query to occur

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/ConvertTo-PokemonTCGQueryString.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/ConvertTo-PokemonTCGQueryString.html)

