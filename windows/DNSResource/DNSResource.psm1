enum ensure {
    Absent
    Present
}

function Get-DNSServerAddress {
    param(
        [ensure]$ensure,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serverAddress
    )

    $ensureReturn = 'Absent'

    $interfaceIndex = Get-NetIPAddress -AddressFamily IPv4 -IPAddress $ipAddress |
        Select-Object -First 1 -ExpandProperty InterfaceIndex
    if ($serverAddress -in (Get-DnsClientServerAddress -InterfaceIndex $interfaceIndex -Family IPv4)) {
        $ensureReturn = $true
    }

    return @{
        ensure = $ensureReturn
        ipAddress = $ipAddress
        serverAddress = $serverAddress
    }
}

function Set-DNSServerAddress {
    param(
        [ensure]$ensure = 'Present',
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serverAddress
    )

    $interfaceIndex = Get-NetIPAddress -AddressFamily IPv4 -IPAddress $ipAddress |
        Select-Object -First 1 -ExpandProperty InterfaceIndex
    Set-DnsClientServerAddress -InterfaceIndex $interfaceIndex -ServerAddresses $serverAddress
}

function Test-DNSServerAddress {
    param(
        [ensure]$ensure = 'Present',
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$serverAddress
    )

    $test = $false
    $get = Get-DNSServerAddress @PSBoundParameters
    if ($get.ensure -eq $ensure) {
        $test = $true
    }

    return $test
}

[DscResource()]
class DNSServerAddress {
    [DscProperty(Mandatory)]
    [ensure] $ensure

    [DscProperty(Key)]
    [string] $ipAddress

    [DscProperty(Key)]
    [string] $serverAddress

    [DNSServerAddress] Get() {
        $ip = Get-DNSServerAddress -ensure $this.ensure -ipAddress $this.ipAddress -serverAddress $this.serverAddress
        return $ip
    }

    [void] Set() {
        Set-DNSServerAddress -ensure $this.ensure -ipAddress $this.ipAddress -serverAddress $this.serverAddress
    }

    [bool] Test() {
        return Test-DNSServerAddress -ensure $this.ensure -ipAddress $this.ipAddress -serverAddress $this.serverAddress
    }
}
