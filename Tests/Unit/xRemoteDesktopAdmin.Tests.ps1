$Global:DSCModuleName      = 'xRemoteDesktopAdmin'
$Global:DSCResourceName    = 'xRemoteDesktopAdmin'

#region HEADER
[String] $moduleRoot = Split-Path -Parent (Split-Path -Parent (Split-Path -Parent $Script:MyInvocation.MyCommand.Path))
if ( (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
     (-not (Test-Path -Path (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) )
{
    & git @('clone','https://github.com/PowerShell/DscResource.Tests.git',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'))
}
else
{
    & git @('-C',(Join-Path -Path $moduleRoot -ChildPath '\DSCResource.Tests\'),'pull')
}
Import-Module (Join-Path -Path $moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1') -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $Global:DSCModuleName `
    -DSCResourceName $Global:DSCResourceName `
    -TestType Unit
#endregion

# Begin Testing
try
{
    #region Pester Tests
    InModuleScope $Global:DSCResourceName {

        Describe $Global:DSCResourceName {

            Context "$($Global:DSCResourceName)\Test-TargetResource" {

                It 'Should return true if RDP is enabled, User Authentication is Secure and Ensure is set "Present" and User Authentication is set to "Secure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Present" -UserAuthentication "Secure" | Should Be $true
                }

                It 'Should return true if RDP is enabled, User Authentication is nonsecure and Ensure is set "Present" and User Authentication is set to "Nonsecure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Present" -UserAuthentication "NonSecure" | Should Be $true
                }


                It 'Should return true if RDP is disabled, User Authentication is nonsecure and Ensure is set "Absent" and User Authentication is set to "Nonsecure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Absent" -UserAuthentication "NonSecure" | Should Be $true
                }

                It 'Should return true if RDP is disabled, User Authentication is secure and Ensure is set "Absent" and User Authentication is set to "secure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Absent" -UserAuthentication "Secure"| Should Be $true
                }


                It 'Should return false if RDP is disable, User Authentication is Secure and Ensure is set "Present" and User Authentication is set to "Secure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Present" -UserAuthentication "Secure" | Should Be $false
                }

                It 'Should return false if RDP is enabled, User Authentication is nonsecure and Ensure is set "Present" and User Authentication is set to "Secure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Present" -UserAuthentication "Secure" | Should Be $false
                }

                It 'Should return false if RDP is enabled, User Authentication is nonsecure and Ensure is set "Absent" and User Authentication is set to "Nonsecure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Absent" -UserAuthentication "NonSecure" | Should Be $false
                }

                It 'Should return false if RDP is disabled, User Authentication is NonSecure and Ensure is set "Absent" and User Authentication is set to "secure"' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Test-TargetResource -Ensure "Absent" -UserAuthentication "Secure"| Should Be $false
                }
            }
            Context "$($Global:DSCResourceName)\Set-TargetResource" {
                Mock -CommandName Set-ItemProperty
                It 'Should enable RDP and enable Secure User Authenciation if both are disabled and Ensure is set to "Present" and UserAuthenticaton is set to "Secure"'{
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Set-TargetResource -Ensure "Present" -UserAuthentication "Secure"
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'fDenyTSConnections' -and $Value -eq "0"} -Times 1 -Exactly
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'UserAuthentication' -and $Value -eq "1"} -Times 1 -Exactly
                }

                It 'Should disable RDP and disable Secure User Authenication if both are enabled and Ensure is set to "Absent" and UserAuthenticaton is set to "NonSecure"'{
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Set-TargetResource -Ensure "Absent" -UserAuthentication "Nonsecure"
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'fDenyTSConnections' -and $Value -eq "1"} -Times 1 -Exactly
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'UserAuthentication' -and $Value -eq "0"} -Times 1 -Exactly
                }

                It 'Should enable Secure User Authenciation if RDP is enabled but Secure User Authentication is disabled and Ensure is set to "Present" and UserAuthenticaton is set to "Secure"'{
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Set-TargetResource -Ensure "Present" -UserAuthentication "Secure"
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'UserAuthentication' -and $Value -eq "1"} -Times 2 -Exactly
                }

                It 'Should disable Secure User Authenciation if RDP is enabled but Secure User Authentication is enabled and Ensure is set to "Present" and UserAuthenticaton is set to "NonSecure"'{
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    Set-TargetResource -Ensure "Present" -UserAuthentication "Secure"
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'fDenyTSConnections' -and $Value -eq "0"} -Times 1 -Exactly
                    Assert-MockCalled -CommandName Set-ItemProperty -ParameterFilter {$Name -eq 'UserAuthentication' -and $Value -eq "0"} -Times 1 -Exactly
                }
            }
            Context "$($Global:DSCResourceName)\Get-TargetResource" {
                It 'should not throw when Ensure set to Present and UserAuthentication set to Secure' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    {Get-TargetResource -Ensure "Present" -UserAuthentication "Secure"} | Should Not Throw
                }
                It 'should not throw when Ensure set to Absent and UserAuthentication set to Secure' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    {Get-TargetResource -Ensure "Absent" -UserAuthentication "NonSecure"} | Should Not Throw
                }
                It 'should not throw when Ensure set to Present and UserAuthentication set to NonSecure' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=0}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=0}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    {Get-TargetResource -Ensure "Present" -UserAuthentication "NonSecure"} | Should Not Throw
                }
                It 'should not throw when Ensure set to Absent and UserAuthentication set to NonSecure' {
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{fDenyTSConnections=1}} -ParameterFilter {$Name -eq 'fDenyTSConnections'}
                    Mock -CommandName Get-ItemProperty -MockWith {[PSCustomObject]@{UserAuthentication=1}} -ParameterFilter {$Name -eq 'UserAuthentication'}
                    {Get-TargetResource -Ensure "Absent" -UserAuthentication "NonSecure"} | Should Not Throw
                }
                It 'Should return a hashtable containing ' {
                    $Result = Get-TargetResource -Ensure "Present"
                    $Result.GetType().Fullname | Should Be 'System.Collections.Hashtable'
                    $Result.Keys | Sort-Object | Should Be @('Ensure', 'UserAuthentication')
                }
            }
        }
    }
}
finally
{
    #region FOOTER
    Restore-TestEnvironment -TestEnvironment $TestEnvironment
    #endregion
}
