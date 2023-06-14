enum ensure {
    Absent
    Present
}

class DomainControllerDscResourceReason {
    [DscProperty()]
    [string] $Code

    [DscProperty()]
    [string] $Phrase
}

function Get-DomainControllerReplica {
    param(
        [ensure]$ensure,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$domainName,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$computerName,
        [System.Management.Automation.PSCredential]$credential
    )

    $ensureReturn = 'Absent'

    $domainControllerFound = [DomainControllerDscResourceReason]::new()
    $domainControllerFound.Code = 'domainController:found'

    try {
        $domainController = Get-ADDomainController -Identity "$computerName.$domainName" -Credential $credential -ErrorAction SilentlyContinue
        if ($domainController.HostName -eq "$computerName.$domainName") {
            $ensureReturn = 'Present'
        } else {
            $domainControllerFound.Phrase = 'The Domain Controller does not exist.'
        }

        return @{
            ensure = $ensureReturn
            domainName = $domainController.Domain
            computerName = $computerName
            Reasons = @($domainControllerFound)
        }
    } catch {
        return @{
            ensure = $ensureReturn
            domainName = $domainController.Domain
            computerName = $computerName
            Reasons = @($domainControllerFound)
        }
    }
}

function Set-DomainControllerReplica {
    param(
        [ensure]$ensure = 'Present',
        [System.Management.Automation.PSCredential]$credential,
        [SecureString]$dsrmPassword,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$domainName,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$computerName
    )

    $sourceDC = Get-ADDomainController -Discover -DomainName $domainName |
        Select-Object -First 1 -ExpandProperty HostName
    Install-ADDSDomainController -Credential $credential -DomainName $domainName -CreateDnsDelegation:$false -InstallDns:$true -ReplicationSourceDC $sourceDC -SafeModeAdministratorPassword $dsrmPassword -DatabasePath "C:\Windows\NTDS" -LogPath "C:\Windows\NTDS" -SysvolPath "C:\Windows\SYSVOL" -Force:$true
}

function Test-DomainControllerReplica {
    param(
        [ensure]$ensure = 'Present',
        [System.Management.Automation.PSCredential]$credential,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$domainName,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$computerName
    )

    $test = $false

    $get = Get-DomainControllerReplica @PSBoundParameters
    if ($get.ensure -eq $ensure) {
        $test = $true
    }

    return $test
}

[DscResource()]
class DomainControllerReplica {
    [DscProperty(Mandatory)]
    [ensure] $ensure

    [DscProperty()]
    [System.Management.Automation.PSCredential] $domainCredential

    # TODO: Something better than this awful string usage. Weird errors with SecureString.
    [DscProperty()]
    [String] $dsrmPassword

    [DscProperty(Key)]
    [String] $domainName

    [DscProperty(Key)]
    [String] $computerName

    [DscProperty(NotConfigurable)]
    [DomainControllerDscResourceReason[]] $Reasons

    [DomainControllerReplica] Get() {
        $domainController = Get-DomainControllerReplica -ensure $this.ensure -domainName $this.domainName -computerName $this.computerName -Credential $this.domainCredential
        return $domainController
    }

    # TODO: Something better than this awful SecureString creation that doesn't produce weird errors.
    [void] Set() {
        Set-DomainControllerReplica -ensure $this.ensure -domainName $this.domainName -computerName $this.computerName -dsrmPassword (ConvertTo-SecureString $this.dsrmPassword -AsPlainText -Force) -Credential $this.domainCredential
    }

    [bool] Test() {
        return Test-DomainControllerReplica -ensure $this.ensure -domainName $this.domainName -computerName $this.computerName -Credential $this.domainCredential
    }
}
