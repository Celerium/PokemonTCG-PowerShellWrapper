---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Test-PokemonTCGApiKey.html
parent: GET
schema: 2.0.0
title: Test-PokemonTCGApiKey
---

# Test-PokemonTCGApiKey

## SYNOPSIS
Test the PokemonTCG API key

## SYNTAX

```powershell
Test-PokemonTCGApiKey [[-BaseURI] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Test-PokemonTCGApiKey cmdlet tests the base URI & API key that were defined in the
Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

## EXAMPLES

### EXAMPLE 1
```powershell
Test-PokemonTCGBaseURI
```

Tests the base URI & API key that was defined in the
Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

The default full base uri test path is:
    https://api.pokemontcg.io/v2/types

### EXAMPLE 2
```powershell
Test-PokemonTCGBaseURI -BaseURI http://myapi.gateway.celerium.org
```

Tests the base URI & API key that was defined in the
Add-PokemonTCGBaseURI & Add-PokemonTCGApiKey cmdlets

The full base uri test path in this example is:
    http://myapi.gateway.celerium.org/types

## PARAMETERS

### -BaseURI
Define the base URI for the PokemonTCG API connection using PokemonTCG's URI or a custom URI

The default base URI is https://api.pokemontcg.io/v2

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: $PokemonTCG_BaseURI
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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Test-PokemonTCGApiKey.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Test-PokemonTCGApiKey.html)

