$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Write-Host "We are in the main.Tests.ps1 file now..."

Describe "main" {
    It "does something useful" {
        Mock Get-Circle { return 1}
        Get-Circle -RootDir "$PSScriptRoot" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose  | Should -Be 1
    }
}