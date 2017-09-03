Configuration xEnableSecureRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin
    node "localhost" {
        xRemoteDesktopAdmin RemoteDesktopAdmin
        {
            Ensure = "Present"
            UserAuthentication = "Secure"
        }
    }
}

Configuration xEnableNonSecureRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin
    node "localhost" {
        xRemoteDesktopAdmin RemoteDesktopAdmin
        {
            Ensure = "Present"
            UserAuthentication = "NonSecure"
        }
    }
}

Configuration xDisableSecureRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin
    node "localhost" {
        xRemoteDesktopAdmin RemoteDesktopAdmin
        {
            Ensure = "Absent"
            UserAuthentication = "Secure"
        }
    }
}

Configuration xDisableNonSecureRDP
{
    Import-DscResource -ModuleName xRemoteDesktopAdmin
    node "localhost" {
        xRemoteDesktopAdmin RemoteDesktopAdmin
        {
            Ensure = "Absent"
            UserAuthentication = "NonSecure"
        }
    }
}
