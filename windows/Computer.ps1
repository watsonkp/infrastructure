Configuration Computer {

    Import-DscResource -ModuleName PsDesiredStateConfiguration
    Import-DscResource -ModuleName DNSResource

    $AllNodes | ForEach-Object {
        Node $_.NodeName {
            DNSServerAddress DNS {
                Ensure = 'Present'
                IPAddress = $_.InterfaceAddress
                ServerAddress = $_.DNSServerAddress
            }

            # Retrieve Name and ProductId from msi file with Orca from Windows SDK or verbose error messages.
            Package PWSH {
                Ensure = 'Present'
                Name = 'PowerShell 7-x64'
                Path = 'https://github.com/PowerShell/PowerShell/releases/download/v7.3.4/PowerShell-7.3.4-win-x64.msi'
                ProductId = '11479679-5C7F-477F-869F-3ED956CE684D'
                Arguments = 'USE_MU=1 ENABLE_MU=1 ADD_EXPLORER_CONTEXT_MENU_OPERNPOWERSHELL=1 ADD_FILE_CONTEXT_MENU_RUNPOWERSHELL=1 REGISTER_MANIFEST=1 ADD_PATH=1 DISABLE_TELEMETRY=1'
            }
        }
    }
}
