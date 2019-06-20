# xRemoteDesktopAdmin

The **xRemoteDesktopAdmin** module contains the **xRemoteDesktopAdmin** DSC resource for configuring Remote Desktop settings on a computer.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Resources

### xRemoteDesktopAdmin

* **Ensure**: Ensures that 'remote connections to this computer' are allowed or disallowed: { Absent | Present }
* **UserAuthentication**: Enables or disables 'Network Level Authentication'. Valid values are:
  * Secure
  * NonSecure

## Examples

### [ExampleConfiguration-RemoteDesktopAdmin.ps1](Examples/ExampleConfiguration-RemoteDesktopAdmin.ps1)

This configuration configures the target system to allow for remote connections (i.e. allows an RDP session to be setup), enables Network Level Authentication and creates a Windows firewall rule to allow incoming RDP traffic.

### [ExampleConfiguration-RemoteDesktopAdminWithUnEncryptedPassword.ps1](Examples/ExampleConfiguration-RemoteDesktopAdminWithUnEncryptedPassword.ps1)

This configuration extends the previous configuration by adding a domain user to the local Remote Desktop Users group using a credential stored in clear text (for testing purposes only).
Note: this Example requires the built-in **Group** resource.

### [ExampleConfiguration-RemoteDesktopAdminWithEncryptedPassword.ps1](Examples/ExampleConfiguration-RemoteDesktopAdminWithEncryptedPassword.ps1)

This configuration extends the previous configuration by adding a domain user to the local Remote Desktop Users group using certificates to encrypt credentials. Please refer to [this blog post](please refer to http://blogs.msdn.com/b/powershell/archive/2014/01/31/want-to-secure-credentials-in-windows-powershell-desired-state-configuration.aspx) for more info on how to use certificates to encrypt passwords.

## Branches

### master

[![Build status](https://ci.appveyor.com/api/projects/status/iwctay9q3t2c72r8/branch/master?svg=true)](https://ci.appveyor.com/project/PowerShell/xActiveDirectory/branch/master)
[![codecov](https://codecov.io/gh/PowerShell/xRemoteDesktopAdmin/branch/master/graph/badge.svg)](https://codecov.io/gh/PowerShell/xRemoteDesktopAdmin/branch/master)

This is the branch containing the latest release -
no contributions should be made directly to this branch.

### dev

[![Build status](https://ci.appveyor.com/api/projects/status/iwctay9q3t2c72r8/branch/dev?svg=true)](https://ci.appveyor.com/project/PowerShell/xRemoteDesktopAdmin/branch/dev)
[![codecov](https://codecov.io/gh/PowerShell/xRemoteDesktopAdminy/branch/dev/graph/badge.svg)](https://codecov.io/gh/PowerShell/xRemoteDesktopAdmin/branch/dev)

This is the development branch
to which contributions should be proposed by contributors as pull requests.
This development branch will periodically be merged to the master branch,
and be released to [PowerShell Gallery](https://www.powershellgallery.com/).

## Contributing

Please check out common DSC Resource [contributing guidelines](https://github.com/PowerShell/DscResources/blob/master/CONTRIBUTING.md).

## Change log

A full list of changes in each version can be found in the [change log](CHANGELOG.md).
