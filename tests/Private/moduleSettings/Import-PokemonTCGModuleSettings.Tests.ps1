<#
    .SYNOPSIS
        Pester tests for the PokemonTCG ModuleSettings functions

    .DESCRIPTION
        Pester tests for the PokemonTCG ModuleSettings functions

    .PARAMETER moduleName
        The name of the local module to import

    .PARAMETER Version
        The version of the local module to import

    .PARAMETER buildTarget
        Which version of the module to run tests against

        Allowed values:
            'built', 'notBuilt'

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ModuleSettings\Get-PokemonTCGModuleSettings.Tests.ps1

        Runs a pester test and outputs simple results

    .EXAMPLE
        Invoke-Pester -Path .\Tests\Private\ModuleSettings\Get-PokemonTCGModuleSettings.Tests.ps1 -Output Detailed

        Runs a pester test and outputs detailed results

    .INPUTS
        N/A

    .OUTPUTS
        N/A

    .NOTES
        N/A

    .LINK
        https://celerium.org

#>

<############################################################################################
                                        Code
############################################################################################>
#Requires -Version 5.1
#Requires -Modules @{ ModuleName='Pester'; ModuleVersion='5.5.0' }

#Region     [ Parameters ]

#Available in Discovery & Run
[CmdletBinding()]
param (
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string]$moduleName = 'PokemonTCG',

    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$version,

    [Parameter(Mandatory=$true)]
    [ValidateSet('built','notBuilt')]
    [string]$buildTarget
)

#EndRegion  [ Parameters ]

#Region     [ Prerequisites ]

#Available inside It but NOT Describe or Context
    BeforeAll {

        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('\tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }
        else{
            $rootPath = "$( $PSCommandPath.Substring(0, $PSCommandPath.IndexOf('/tests', [System.StringComparison]::OrdinalIgnoreCase)) )"
        }

        switch ($buildTarget) {
            'built'     { $modulePath = Join-Path -Path $rootPath -ChildPath "\build\$moduleName\$version" }
            'notBuilt'  { $modulePath = Join-Path -Path $rootPath -ChildPath "$moduleName" }
        }

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

        $modulePsd1 = Join-Path -Path $modulePath -ChildPath "$moduleName.psd1"
        $invalidPath = $(Join-Path -Path $home -ChildPath "invalidApiPath")
        if ($IsWindows -or $PSEdition -eq 'Desktop') {
            $exportPath = $(Join-Path -Path $home -ChildPath "PokemonTCG_Test")
        }
        else{
            $exportPath = $(Join-Path -Path $home -ChildPath ".PokemonTCG_Test")
        }

        Import-Module -Name $modulePsd1 -ErrorAction Stop -ErrorVariable moduleError *> $null

        if ($moduleError) {
            $moduleError
            exit 1
        }

    }

    AfterAll{

        Remove-PokemonTCGModuleSettings -PokemonTCGConfPath $exportPath

        if (Get-Module -Name $moduleName) {
            Remove-Module -Name $moduleName -Force
        }

    }

#Available in Describe and Context but NOT It
#Can be used in [ It ] with [ -TestCases @{ VariableName = $VariableName } ]
    BeforeDiscovery{

        $pester_TestName = (Get-Item -Path $PSCommandPath).Name
        $commandName = $pester_TestName -replace '.Tests.ps1',''

    }

#EndRegion  [ Prerequisites ]

Describe "Testing [ $commandName ] function with [ $pester_TestName ]" -Tag @('moduleSettings') {

    Context "[ $commandName ] testing function" {

        It "No configuration should populate baseline variables" {
            Import-PokemonTCGModuleSettings -PokemonTCGConfPath $invalidPath -PokemonTCGConfFile 'invalid.psd1'

            (Get-Variable -Name PokemonTCG_BaseURI).Value | Should -Be $(Get-PokemonTCGBaseURI)
            (Get-Variable -Name PokemonTCG_JSON_Conversion_Depth).Value | Should -Not -BeNullOrEmpty
        }

        It "Saved configuration session should contain required variables" {
            Add-PokemonTCGBaseUri
            Add-PokemonTCGApiKey -ApiKey '12345'

            Export-PokemonTCGModuleSettings -PokemonTCGConfPath $exportPath -WarningAction SilentlyContinue
            Import-PokemonTCGModuleSettings -PokemonTCGConfPath $exportPath

            (Get-Variable -Name PokemonTCG_BaseURI).Value | Should -Not -BeNullOrEmpty
            (Get-Variable -Name PokemonTCG_API_Key).Value | Should -Not -BeNullOrEmpty
            (Get-Variable -Name PokemonTCG_JSON_Conversion_Depth).Value | Should -Not -BeNullOrEmpty
        }

        It "Saved configuration session should NOT contain temp variables" {
            Add-PokemonTCGBaseUri
            Add-PokemonTCGApiKey -ApiKey '12345'

            Export-PokemonTCGModuleSettings -PokemonTCGConfPath $exportPath -WarningAction SilentlyContinue
            Import-PokemonTCGModuleSettings -PokemonTCGConfPath $exportPath

            (Get-Variable -Name tmp_config -ErrorAction SilentlyContinue).Value | Should -BeNullOrEmpty
        }

    }

}