Configuration DC {
    Import-DscResource -ModuleName PsDesiredStateConfiguration

    Node 'localhost' {
        WindowsFeature ADDS {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
        }

        WindowsFeatureSet ServicesAndTools {
            Ensure = 'Present'
            Name = @('ADCS-Cert-Authority', 'DNS', 'RSAT-AD-PowerShell')
        }
    }
}
