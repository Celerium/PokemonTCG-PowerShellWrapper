---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGBaseURI.html
parent: POST
schema: 2.0.0
title: Add-PokemonTCGBaseURI
---

# Add-PokemonTCGBaseURI

## SYNOPSIS
Sets the base URI for the PokemonTCG API

## SYNTAX

```powershell
Add-PokemonTCGBaseURI [[-BaseURI] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-PokemonTCGBaseURI cmdlet sets the base URI which is later used
to construct the full URI for all API calls

## EXAMPLES

### EXAMPLE 1
```powershell
Add-PokemonTCGBaseURI
```

The base URI will use https://api.pokemontcg.io/v2 which is
PokemonTCG's default URI

### EXAMPLE 2
```powershell
Add-PokemonTCGBaseURI -BaseURI http://myapi.gateway.celerium.org
```

A custom API gateway of http://myapi.gateway.celerium.org will be used
for all API calls to PokemonTCG's API

## PARAMETERS

### -BaseURI
Define the base URI for the PokemonTCG API connection

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: Https://api.pokemontcg.io/v2
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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGBaseURI.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGBaseURI.html)

