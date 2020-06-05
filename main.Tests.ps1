$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

# To run pester tests
Write-Host "Importing module... Pester"
Import-Module Pester -Force

Describe "main" {
    It "does something useful" {
        Get-Circle -RootDir "$PSScriptRoot" -SaveAsJSON -SaveAsCSV -SaveAsTable -Verbose 
        $true | Should -Be $false
    }   

    Context "when user forgets to provide input pdf file to analyse" {
        It "Exit's the program, with a warning to provide input files"{
            $false| Should -Be $true
        }
    }
}