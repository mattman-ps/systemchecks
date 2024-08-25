BeforeDiscovery {
    Set-Location -Path $PSScriptRoot
    $ModuleName = 'systemchecks'
    $PathToManifest = [System.IO.Path]::Combine('..', '..', '..', $ModuleName, "$ModuleName.psd1")
    #if the module is already in memory, remove it
    Get-Module $ModuleName -ErrorAction SilentlyContinue | Remove-Module -Force
    Import-Module $PathToManifest -Force
}

InModuleScope 'systemchecks' {
    #-------------------------------------------------------------------------
    $WarningPreference = "SilentlyContinue"
    #-------------------------------------------------------------------------
    Describe 'Get-Day Private Function Tests' -Tag Unit {
        BeforeAll {
            $WarningPreference = 'SilentlyContinue'
            $ErrorActionPreference = 'SilentlyContinue'
        } #beforeAll
        Context 'Error' {

            It 'should return unknown if an error is encountered getting the uri' {
                Mock -CommandName Get-Date -MockWith {
                    throw 'Fake Error'
                } #endMock
                Get-Day | Should -BeExactly 'Unknown'
            } #it

        } #context_Error
        Context 'Success' {

            BeforeEach {
                Mock -CommandName Test-Uri -MockWith {
                    [PSCustomObject]@{
                        response = $true
                    }
                } #endMock
            } #beforeEach

            It 'should return the expected results' {
                Test-Uri | Should -BeExactly $true
            } #it

        } #context_Success
    } #describe_Get-HelloWorld
} #inModule

