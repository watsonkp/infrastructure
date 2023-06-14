Configuration DC {
    param(
        [String]$domainName
        [PSCredential]$domainCredential
    )

    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName IPAddressResource
    Import-DscResource -ModuleName DomainControllerResource

    $AllNodes | ForEach-Object {
        Node $_.NodeName {
            StaticIPAddress IP {
                Ensure = 'Present'
                IPAddress = $_.StaticIPAddress
            }

            WindowsFeature ADDS {
                Ensure = 'Present'
                Name = 'AD-Domain-Services'
            }

            WindowsFeatureSet ServicesAndTools {
                Ensure = 'Present'
                Name = @('DNS', 'RSAT-AD-PowerShell')
            }

            DomainControllerReplica DC {
                DomainCredential = $domainCredential
                DsrmPassword = $_.DsrmPassword
                Ensure = 'Present'
                DomainName = $domainName
                ComputerName = $_.NodeName
            }
        }
    }
}
