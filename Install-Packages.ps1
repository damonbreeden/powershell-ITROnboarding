function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information','Warning','Error')]
        [string]$Severity = 'Information',

        [string]$logFile
    )

    If (!($PSBoundParameters.LogFile)) {
        $logFile = "$env:Temp\LogFile.log"
    }

    [pscustomobject]@{
        Time = (Get-Date -f g)
        Message = $Message
        Severity = $Severity
    } | Export-Csv -Path $logFile -Append -NoTypeInformation
}

function Install-Packages {
    <#
.SYNOPSIS
    This function checks for a list of packages online and installs them
.PARAMETER url
    The URL to check
.EXAMPLE
    Install-Packages -url "http://path/to/url.txt"
.NOTES
    Author: Damon Breeden
    Github: https://github.com/damonbreeden
#>

[CmdletBinding()]
param (
[Parameter(Mandatory)]
[string]$packageNameUrl
)

$packages = (((Invoke-WebRequest -Uri $packageNameUrl -UseBasicParsing).Content) -split '\r?\n').Trim()
$logFile = "C:\ITresources\logs\Install-Packages.log"

foreach ($p in $packages) {
    try {
        Install-Module $p -Force
        Write-Log -Severity Information -logFile $logFile "Installed $p successfully"
    }
    catch {
        Write-Log -Severity Error -logFile $logFile -Message "Couldn't install package $p"
        Write-Log -Severity Error -logFile $logFile -Message $_.Exception.Message
    }
}
}



Install-Packages -packageNameUrl https://raw.githubusercontent.com/damonbreeden/powershell-ITROnboarding/master/packageNames.txt