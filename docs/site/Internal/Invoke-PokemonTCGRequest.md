---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Invoke-PokemonTCGRequest.html
parent: GET
schema: 2.0.0
title: Invoke-PokemonTCGRequest
---

# Invoke-PokemonTCGRequest

## SYNOPSIS
Makes an API request

## SYNTAX

```powershell
Invoke-PokemonTCGRequest [[-method] <String>] [-resourceURI] <String> [[-uriFilter] <Hashtable>]
 [[-data] <Hashtable>] [-allPages] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-PokemonTCGRequest cmdlet invokes an API request to PokemonTCG API

This is an internal function that is used by all public functions

As of 2024-11 the PokemonTCG v2 API only supports GETrequests

## EXAMPLES

### EXAMPLE 1
```powershell
Invoke-PokemonTCGRequest -method GET -resourceURI '/cards' -uriFilter $uriFilter
```

Invoke a rest method against the defined resource using any of the provided parameters

Example:
    Name                           Value
    ----                           -----
    method                         GET
    Uri                            https://api.pokemontcg.io/v2/cards?q=name:ditto
    Headers                        {X-Api-Key = 123456789}
    Body

## PARAMETERS

### -method
Defines the type of API method to use

Allowed values:
'GET'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: GET
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceURI
Defines the resource uri (url) to use when creating the API call

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -uriFilter
Used with the internal function \[ ConvertTo-PokemonTCGQueryString \] to combine
a functions parameters with the resourceURI parameter

This allows for the full uri query to occur

The full resource path is made with the following data
$PokemonTCG_BaseURI + $resourceURI + ConvertTo-PokemonTCGQueryString

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -data
Place holder parameter to use when other methods are supported
by the PokemonTCG v2 API

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

When using this parameter there is no need to use the page parameter

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
N/A

## RELATED LINKS

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Invoke-PokemonTCGRequest.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Invoke-PokemonTCGRequest.html)

