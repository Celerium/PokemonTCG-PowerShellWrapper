---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGApiKey.html
parent: GET
schema: 2.0.0
title: Get-PokemonTCGApiKey
---

# Get-PokemonTCGApiKey

## SYNOPSIS
Gets the PokemonTCG API key

## SYNTAX

```powershell
Get-PokemonTCGApiKey [-plainText] [<CommonParameters>]
```

## DESCRIPTION
The Get-PokemonTCGApiKey cmdlet gets the PokemonTCG API key
global variable

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PokemonTCGApiKey
```

Gets the PokemonTCG API key global variable and returns
it as a SecureString

### EXAMPLE 2
```powershell
Get-PokemonTCGApiKey -plainText
```

Gets the PokemonTCG API key global variable and returns
it as plain text

## PARAMETERS

### -plainText
Decrypt and return the API key in plain text

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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGApiKey.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGApiKey.html)

