---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGApiKey.html
parent: POST
schema: 2.0.0
title: Add-PokemonTCGApiKey
---

# Add-PokemonTCGApiKey

## SYNOPSIS
Sets the PokemonTCG API key

## SYNTAX

```powershell
Add-PokemonTCGApiKey [[-ApiKey] <String>] [<CommonParameters>]
```

## DESCRIPTION
The Add-PokemonTCGApiKey cmdlet sets the PokemonTCG API key which is used to
authenticate all API calls made to PokemonTCG

An API key is not required to use the PokemonTCG API.
However if you aren't using
an API key, you are rate limited to 1000 requests a day, and a maximum of 30 per minute

A PokemonTCG API key can be acquired via an account on https://dev.pokemontcg.io/

## EXAMPLES

### EXAMPLE 1
```powershell
Add-PokemonTCGApiKey
```

No API key is set

### EXAMPLE 2
```powershell
Add-PokemonTCGApiKey -ApiKey '12345'
```

Sets the API key to the defined value

### EXAMPLE 3
```
'12345' | Add-PokemonTCGApiKey
```

Sets the API key to the defined value

## PARAMETERS

### -ApiKey
Defines your API secret key

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGApiKey.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Add-PokemonTCGApiKey.html)

