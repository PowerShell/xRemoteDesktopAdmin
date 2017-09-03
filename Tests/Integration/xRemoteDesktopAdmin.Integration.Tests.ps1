$script:DSCModuleName = 'xRemoteDesktopAdmin'
$script:DSCResourceName = 'xRemoteDesktopAdmin'

#region HEADER
# Integration Test Template Version: 1.1.1
[String] $script:moduleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if ( (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests'))) -or `
    (-not (Test-Path -Path (Join-Path -Path $script:moduleRoot -ChildPath 'DSCResource.Tests\TestHelper.psm1'))) ) {
    & git @('clone', 'https://github.com/PowerShell/DscResource.Tests.git', (Join-Path -Path $script:moduleRoot -ChildPath '\DSCResource.Tests\'))
}

Import-Module -Name (Join-Path -Path $script:moduleRoot -ChildPath (Join-Path -Path 'DSCResource.Tests' -ChildPath 'TestHelper.psm1')) -Force
$TestEnvironment = Initialize-TestEnvironment `
    -DSCModuleName $script:DSCModuleName `
    -DSCResourceName $script:DSCResourceName `
    -TestType Integration

#endregion

# Using try/finally to always cleanup.
try 
{
    #region Integration Tests
    $configFile = Join-Path -Path $PSScriptRoot -ChildPath "$($script:DSCResourceName).config.ps1"
    . $configFile

    Describe "$($script:DSCResourceName)_Integration" {
        
        $contexts = @{
            EnableSecureRDP     = 'xEnableSecureRDP'
            EnableNonSecureRDP  = 'xEnableNonSecureRDP'
            DisableSecureRDP    = 'xDisableSecureRDP'
            DisableNonSecureRDP = 'xDisableNonSecureRDP'
        }

        foreach ($contextInfo in $contexts.GetEnumerator())
        {
            Context "[$($contextInfo.Key)] Secure RDP should be enabled" {
                $CurrentConfig = '{0}' -f $contextInfo.Value
                $ConfigDir = (Join-Path -Path $TestDrive -ChildPath $CurrentConfig)
                $ConfigMof = (Join-Path -Path $ConfigDir -ChildPath 'localhost.mof')
            
                It 'should compile and apply the MOF without throwing' {
                    {
                        . $CurrentConfig -OutputPath $ConfigDir
                    } | Should Not Throw
                }

                It 'should apply the MOF correctly' {
                    {
                        Start-DscConfiguration -Path $ConfigDir -Wait -Force
                    } | Should Not Throw
                }

                It 'should return a compliant state after being applied' {
                    (Test-DscConfiguration -ReferenceConfiguration $ConfigMof -Verbose).InDesiredState | Should be $true 
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
