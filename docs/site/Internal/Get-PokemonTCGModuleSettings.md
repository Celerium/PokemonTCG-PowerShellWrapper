---
external help file: PokemonTCG-help.xml
grand_parent: Internal
Module Name: PokemonTCG
online version: https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGModuleSettings.html
parent: GET
schema: 2.0.0
title: Get-PokemonTCGModuleSettings
---

# Get-PokemonTCGModuleSettings

## SYNOPSIS
Gets the saved PokemonTCG configuration settings

## SYNTAX

### index (Default)
```powershell
Get-PokemonTCGModuleSettings [-PokemonTCGConfPath <String>] [-PokemonTCGConfFile <String>] [<CommonParameters>]
```

### show
```powershell
Get-PokemonTCGModuleSettings [-openConfFile] [<CommonParameters>]
```

## DESCRIPTION
The Get-PokemonTCGModuleSettings cmdlet gets the saved PokemonTCG configuration settings
from the local system

By default the configuration file is stored in the following location:
    $env:USERPROFILE\PokemonTCG

## EXAMPLES

### EXAMPLE 1
```powershell
Get-PokemonTCGModuleSettings
```

Gets the contents of the configuration file that was created with the
Export-PokemonTCGModuleSettings

The default location of the PokemonTCG configuration file is:
    $env:USERPROFILE\PokemonTCG\config.psd1

### EXAMPLE 2
```powershell
Get-PokemonTCGModuleSettings -PokemonTCGConfPath C:\PokemonTCG -PokemonTCGConfFile MyConfig.psd1 -openConfFile
```

Opens the configuration file from the defined location in the default editor

The location of the PokemonTCG configuration file in this example is:
    C:\PokemonTCG\MyConfig.psd1

## PARAMETERS

### -PokemonTCGConfPath
Define the location to store the PokemonTCG configuration file

By default the configuration file is stored in the following location:
    $env:USERPROFILE\PokemonTCG

```yaml
Type: String
Parameter Sets: index
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
Parameter Sets: index
Aliases:

Required: False
Position: Named
Default value: Config.psd1
Accept pipeline input: False
Accept wildcard characters: False
```

### -openConfFile
Opens the PokemonTCG configuration file

```yaml
Type: SwitchParameter
Parameter Sets: show
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

[https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGModuleSettings.html](https://celerium.github.io/PokemonTCG-PowerShellWrapper/site/Internal/Get-PokemonTCGModuleSettings.html)

