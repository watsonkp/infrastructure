enum ensure {
    Absent
    Present
}

function Get-StaticIPAddress {
    param(
        [ensure]$ensure,
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress
    )

    $ensureReturn = 'Absent'

    if ($ipAddress -notmatch "^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+") {
        return @{
            ensure = $ensureReturn
            ipAddress = $ipAddress
        }
    }

    Get-NetIPAddress -IPAddress $ipAddress -ErrorAction SilentlyContinue
    if ($?) {
        $ensureReturn = 'Present'
    } else {
        $ensureReturn = 'Absent'
    }

    return @{
        ensure = $ensureReturn
        ipAddress = $ipAddress
    }
}

function Set-StaticIPAddress {
    param(
        [ensure]$ensure = 'Present',
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress
    )

    $ipAddress -match "^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+"
    $subnet = $Matches.1
    if ($subnet -eq $null) {
        return $null
    }
    $defaultGateway = $subnet + ".0"
    $interfaceIndex = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object {$_.IPAddress -match "^([0-9]+\.[0-9]+\.[0-9]+)\.[0-9]+" -and $Matches.1 -eq $subnet} |
        Select-Object -First 1 -ExpandProperty InterfaceIndex
    New-NetIPAddress -InterfaceIndex $interfaceIndex -IPAddress $ipAddress -DefaultGateway $defaultGateway
}

function Test-StaticIPAddress {
    param(
        [ensure]$ensure = 'Present',
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$ipAddress
    )

    $test = $false

    $get = Get-StaticIPAddress @PSBoundParameters
    if ($get.ensure -eq $ensure) {
        $test = $true
    }

    return $test
}

[DscResource()]
class StaticIPAddress {
    [DscProperty(Key)]
    [string] $ipAddress

    [DscProperty(Mandatory)]
    [ensure] $ensure

    [StaticIPAddress] Get() {
        $ip = Get-StaticIPAddress -ensure $this.ensure -ipAddress $this.ipAddress
        return $ip
    }

    [void] Set() {
        Set-StaticIPAddress -ensure $this.ensure -ipAddress $this.ipAddress
    }

    [bool] Test() {
        return Test-StaticIPAddress -ensure $this.ensure -ipAddress $this.ipAddress
    }
}
