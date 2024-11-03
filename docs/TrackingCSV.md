---
title: Tracking CSV
parent: Home
nav_order: 2
---

# Tracking CSV

When updating the documentation for this project, the tracking CSV plays a huge part in organizing of the markdown documents. Any new functions or endpoints should be added to the tracking CSV when publishing an updated module or documentation version

{: .warning }
I recommend downloading the CSV from the link provided rather then viewing the table below

[Tracking CSV](https://github.com/Celerium/PokemonTCG-PowerShellWrapper/blob/main/docs/Endpoints.csv)

---

## CSV markdown table

|Category  |EndpointUri|Method|Function                           |
|----------|-----------|------|-----------------------------------|
|Cards     |/cards/<id>|GET   |Get-PokemonTCGCard                 |
|Cards     |/cards     |GET   |Get-PokemonTCGCard                 |
|Sets      |/sets/<id> |GET   |Get-PokemonTCGSet                  |
|Sets      |/sets      |GET   |Get-PokemonTCGSet                  |
|Types     |/types     |GET   |Get-PokemonTCGType                 |
|Subtypes  |/subtypes  |GET   |Get-PokemonTCGSubtype              |
|Supertypes|/supertypes|GET   |Get-PokemonTCGSupertype            |
|Rarities  |/rarities  |GET   |Get-PokemonTCGRarity               |
|Internal  |           |POST  |Add-PokemonTCGApiKey               |
|Internal  |           |POST  |Add-PokemonTCGBaseURI              |
|Internal  |           |PUT   |ConvertTo-PokemonTCGQueryString    |
|Internal  |           |GET   |Export-PokemonTCGModuleSettings    |
|Internal  |           |GET   |Get-PokemonTCGApiKey               |
|Internal  |           |GET   |Get-PokemonTCGBaseURI              |
|Internal  |           |GET   |Get-PokemonTCGModuleSettings       |
|Internal  |           |GET   |Import-PokemonTCGModuleSettings    |
|Internal  |           |GET   |Invoke-PokemonTCGRequest           |
|Internal  |           |DELETE|Remove-PokemonTCGApiKey            |
|Internal  |           |DELETE|Remove-PokemonTCGBaseURI           |
|Internal  |           |DELETE|Remove-PokemonTCGModuleSettings    |
|Internal  |           |GET   |Test-PokemonTCGApiKey              |
|Internal  |           |POST  |Initialize-PokemonTCGModuleSettings|
