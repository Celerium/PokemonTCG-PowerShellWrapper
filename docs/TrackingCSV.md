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

| Category  | EndpointUri                                                  | Method | Function                   | Complete | Notes                                                 |
| --------- | ------------------------------------------------------------ | ------ | -------------------------- | -------- | ----------------------------------------------------- |
| BCDR      | /bcdr/agent                                                  | GET    | Get-PokemonTCGAgent             | YES      | Used for Endpoint Backup for PC agents (EB4PC) |
| BCDR      | /bcdr/device/{serialNumber}/asset/agent                      | GET    | Get-PokemonTCGAgent             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/alert                            | GET    | Get-PokemonTCGAlert             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/asset                            | GET    | Get-PokemonTCGAsset             | YES      |                                                       |
| BCDR      | /bcdr/                                                       | GET    | Get-PokemonTCGBCDR              | YES      | Special command that combines all BCDR endpoints      |
| BCDR      | /bcdr/device                                                 | GET    | Get-PokemonTCGDevice            | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}                                  | GET    | Get-PokemonTCGDevice            | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/asset/share                      | GET    | Get-PokemonTCGShare             | YES      |                                                       |
| BCDR      | /bcdr/device/{serialNumber}/vm-restores                      | GET    | Get-PokemonTCGVMRestore         | Yes      | Cannot fully validate at this time                    |
| BCDR      | /bcdr/device/{serialNumber}/asset/{volumeName}               | GET    | Get-PokemonTCGVolume            | YES      |                                                       |
| Internal  |                                                              | POST   | Add-PokemonTCGApiKey            | YES      |                                                       |
| Internal  |                                                              | POST   | Add-PokemonTCGBaseURI           | YES      |                                                       |
| Internal  |                                                              | PUT    | ConvertTo-PokemonTCGQueryString | YES      |                                                       |
| Internal  |                                                              | GET    | Export-PokemonTCGModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Get-PokemonTCGApiKey            | YES      |                                                       |
| Internal  |                                                              | GET    | Get-PokemonTCGBaseURI           | YES      |                                                       |
| Internal  |                                                              | GET    | Get-PokemonTCGMetaData          | YES      |                                                       |
| Internal  |                                                              | GET    | Get-PokemonTCGModuleSettings    | YES      |                                                       |
| Internal  |                                                              | GET    | Import-PokemonTCGModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Invoke-PokemonTCGRequest        | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-PokemonTCGApiKey         | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-PokemonTCGBaseURI        | YES      |                                                       |
| Internal  |                                                              | DELETE | Remove-PokemonTCGModuleSettings | YES      |                                                       |
| Internal  |                                                              | GET    | Test-PokemonTCGApiKey           | YES      |                                                       |
| Reporting | /report/activity-log                                         | GET    | Get-PokemonTCGActivityLog       | YES      |                                                       |
| SaaS      | /sass/{sassCustomerId}/applications                          | GET    | Get-PokemonTCGApplication       | YES      |                                                       |
| SaaS      | /saas/{saasCustomerId}/{externalSubscriptionId}/bulkSeatChange | PUT    | Set-PokemonTCGBulkSeatChange    | YES      |                                                       |
| SaaS      | /sass/domains                                                | GET    | Get-PokemonTCGDomain            | YES      |                                                       |
| SaaS      | /sass/                                                       | GET    | Get-PokemonTCGSaaS              | YES      | Special command that combines all SaaS endpoints      |
| SaaS      | /sass/{sassCustomerId}/seats                                 | GET    | Get-PokemonTCGSeat              | YES      |                                                       |
