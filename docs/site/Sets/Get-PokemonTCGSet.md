---
external help file: PokemonTCG-help.xml
grand_parent: Sets
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Sets/Get-PokemonTCGSet.html
parent: GET
schema: 2.0.0
title: Get-PokemonTCGSet
---

# Get-PokemonTCGSet

## SYNOPSIS
Gets PokemonTCG sets

## SYNTAX

### Show (Default)
```powershell
Get-PokemonTCGSet [-select <String>] [-q <String>] [-orderBy <String>] [-page <Int64>] [-pageSize <Int64>]
 [-allPages] [<CommonParameters>]
```

### Index
```powershell
Get-PokemonTCGSet -id <String> [-select <String>] [<CommonParameters>]
```

## DESCRIPTION
The Get-PokemonTCGSet cmdlet gets PokemonTCG sets individually, in bulk,
& or with advanced query filters (Filters are case-sensitive)

Details on allowed queries can be found at
https://docs.pokemontcg.io/api-reference/sets/set-object#attributes

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PokemonTCGSet
```

Gets the first 250 PokemonTCG sets

### EXAMPLE 2
```powershell
Get-PokemonTCGSet -id base1
```

Returns the set with the defined id

### EXAMPLE 3
```
'base1' | Get-PokemonTCGSet
```

Returns the set with the defined id

### EXAMPLE 4
```powershell
Get-PokemonTCGSet -q 'series:base'
```

Returns the first 250 sets with the defined series

### EXAMPLE 5
```powershell
Get-PokemonTCGSet -q 'name:base*' -Verbose
```

Returns the first 250 sets that start with the defined name

Progress information is sent to the console while the cmdlet is running

### EXAMPLE 6
```powershell
Get-PokemonTCGSet -q 'series:base printedTotal:[* TO 102]' -Verbose
```

Returns the first 250 sets from the defined series that contain up to 102 printed cards

Progress information is sent to the console while the cmdlet is running

## PARAMETERS

### -id
The id of the set

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
The PokemonTCG sets object contains the following attributes: (https://docs.pokemontcg.io/api-reference/sets/set-object#attributes)
id string
name string
series string
printedTotal integer
total integer
legalities hash
ptcgoCode string
releaseDate string
updatedAt string
images hash

## RELATED LINKS

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Sets/Get-PokemonTCGSet.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Sets/Get-PokemonTCGSet.html)

[https://docs.pokemontcg.io/api-reference/sets/set-object#attributes](https://docs.pokemontcg.io/api-reference/sets/set-object#attributes)

