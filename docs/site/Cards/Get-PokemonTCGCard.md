---
external help file: PokemonTCG-help.xml
grand_parent: Cards
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Cards/Get-PokemonTCGCard.html
parent: GET
schema: 2.0.0
title: Get-PokemonTCGCard
---

# Get-PokemonTCGCard

## SYNOPSIS
Gets PokemonTCG cards

## SYNTAX

### Show (Default)
```powershell
Get-PokemonTCGCard [-select <String>] [-q <String>] [-orderBy <String>] [-page <Int64>] [-pageSize <Int64>]
 [-allPages] [<CommonParameters>]
```

### Index
```powershell
Get-PokemonTCGCard -id <String> [-select <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-PokemonTCGCard cmdlet gets PokemonTCG cards individually, in bulk,
& or with advanced query filters (Filters are case-sensitive)

Details on allowed queries can be found at
https://docs.pokemontcg.io/api-reference/cards/card-object

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PokemonTCGCard
```

Gets the first 250 PokemonTCG cards

### EXAMPLE 2
```powershell
Get-PokemonTCGCard -id base3-3
```

Returns the PokemonTCG ditto object with the defined id

### EXAMPLE 3
```
'base3-3' | Get-PokemonTCGCard
```

Returns the PokemonTCG ditto object with the defined id

### EXAMPLE 4
```powershell
Get-PokemonTCGCard -q 'name:ditto'
```

Returns the first 250 ditto's from the PokemonTCG API

### EXAMPLE 5
```powershell
Get-PokemonTCGCard -q 'nationalPokedexNumbers:132'
```

Returns the first 250 ditto's from the PokemonTCG API

### EXAMPLE 6
```powershell
Get-PokemonTCGCard -q 'set.id:base*' -Verbose
```

Returns the first 250 pokemon from any base set starting with the
defined term from the PokemonTCG API

Progress information is sent to the console while the cmdlet is running

### EXAMPLE 7
```powershell
Get-PokemonTCGCard -q 'set.id:base* types:water' -Verbose
```

Returns the first 250 water type pokemon from any base set starting with the
defined term from the PokemonTCG API

Progress information is sent to the console while the cmdlet is running

## PARAMETERS

### -id
The id of the card

```yaml
Type: String
Parameter Sets: Index
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -select
A comma delimited list of fields to return in the response

By default, all fields are returned if not defined

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -q
The search query

```yaml
Type: String
Parameter Sets: Show
Aliases: query

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -orderBy
The field(s) to order the results by

```yaml
Type: String
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -page
Defines the page number to return

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -pageSize
Defines the amount of items to return with each page

```yaml
Type: Int64
Parameter Sets: Show
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -allPages
Returns all items from an endpoint

When using this parameter there is no need to use the page parameter

```yaml
Type: SwitchParameter
Parameter Sets: Show
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
The PokemonTCG card object contains the following attributes: (https://docs.pokemontcg.io/api-reference/cards/card-object#attributes)
    id string
    name string
    supertype string
    subtypes list(string)
    level string
    hp string
    types list(string)
    evolvesFrom string
    evolvesTo list(string)
    rules list(string)
    ancientTrait hash
    abilities list(hash)
    attacks list(hash)
    weaknesses list(hash)
    resistances list(hash)
    retreatCost list(string)
    convertedRetreatCost integer
    set hash
    number string
    artist string
    rarity string
    flavorText string
    nationalPokedexNumbers list(integer)
    legalities hash
    regulationMark string
    images hash
    tcgplayer hash
    cardmarket hash

## RELATED LINKS

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/cards/Get-PokemonTCGCard.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/cards/Get-PokemonTCGCard.html)

[https://docs.pokemontcg.io/api-reference/cards/card-object#attributes](https://docs.pokemontcg.io/api-reference/cards/card-object#attributes)

