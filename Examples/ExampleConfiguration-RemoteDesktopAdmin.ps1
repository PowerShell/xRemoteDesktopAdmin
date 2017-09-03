Configuration Example
{
    param
    (
        [Parameter()]
        [System.String[]]
        $NodeName = 'localhost'
    )
    Import-DscResource -Module xRemoteDesktopAdmin, xNetworking

    Node $NodeName
    {        
        xRemoteDesktopAdmin RemoteDesktopSettings
        {
           Ensure = 'Present'
           UserAuthentication = 'Secure'
        }

        xFirewall AllowRDP
        {
            DisplayName = 'DSC - Remote Desktop Admin Connections'
            Name = "Remote Desktop"
            Ensure = 'Present'
            Enabled = 'True'
            Action = 'Allow'
            Profile = 'Domain'
        }
    }
}
