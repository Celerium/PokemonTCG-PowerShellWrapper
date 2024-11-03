---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Import-PokemonTCGModuleSettings.html
parent: GET
schema: 2.0.0
title: Import-PokemonTCGModuleSettings
---

# Import-PokemonTCGModuleSettings

## SYNOPSIS
Imports the PokemonTCG BaseURI, API, & JSON configuration information to the current session

## SYNTAX

```powershell
Import-PokemonTCGModuleSettings [-PokemonTCGConfPath <String>] [-PokemonTCGConfFile <String>]
 [<CommonParameters>]
```

## DESCRIPTION
The Import-PokemonTCGModuleSettings cmdlet imports the PokemonTCG BaseURI, API, & JSON configuration
information stored in the PokemonTCG configuration file to the users current session

By default the configuration file is stored in the following location:
    $env:USERPROFILE\PokemonTCG

## EXAMPLES

### EXAMPLE 1
```powershell
Import-PokemonTCGModuleSettings
```

Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
then imports the stored data into the current users session

The default location of the PokemonTCG configuration file is:
    $env:USERPROFILE\PokemonTCG\config.psd1

### EXAMPLE 2
```powershell
Import-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1
```

Validates that the configuration file created with the Export-PokemonTCGModuleSettings cmdlet exists
then imports the stored data into the current users session

The location of the PokemonTCG configuration file in this example is:
    C:\PokemonTCG\MyConfig.psd1

## PARAMETERS

### -PokemonTCGConfPath
Define the location to store the PokemonTCG configuration file

By default the configuration file is stored in the following location:
    $env:USERPROFILE\PokemonTCG

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: $(Join-Path -Path $home -ChildPath $(if ($IsWindows -or $PSEdition -eq 'Desktop') {"PokemonTCG"}else{".PokemonTCG"}) )
Accept pipeline input: False
Accept wildcard characters: False
```

### -PokemonTCGConfFile
Define the name of the PokemonTCG configuration file

By default the configuration file is named:
    config.psd1

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Config.psd1
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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Import-PokemonTCGModuleSettings.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Import-PokemonTCGModuleSettings.html)

