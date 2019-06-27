function Write-Log {
    [CmdletBinding()]
    param(
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [ValidateSet('Information', 'Warning', 'Error')]
        [string]$Severity = 'Information',

        [string]$logFile
    )

    If (!($PSBoundParameters.LogFile)) {
        $logFile = "$env:Temp\LogFile.log"
    }

    #Tests to make sure the logfile is writeable, if not puts it in the %temp% directory
    #First have to check if it's Windows otherwise it bombs out on my machine
    If ($IsWindows) {
        Try {
            [io.file]::OpenWrite($logFile).close()
        }
        Catch {
            $logFile = "$env:Temp\LogFile.log"
        }
    }

    [pscustomobject]@{
        Time     = (Get-Date -f g)
        Message  = $Message
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
    Install-Packages -url "http://path/to/url.json"
.NOTES
    Author: Damon Breeden
    Github: https://github.com/damonbreeden
#>

    #Requires -Version 5

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$packageNameUrl
    )

    $packages = ((Invoke-WebRequest -Uri $packageNameUrl -UseBasicParsing).Content) | ConvertFrom-Json
    $logFile = "C:\ITresources\logs\Install-Packages.log"

    foreach ($p in $packages.PSObject.Properties) {
        $name = $p.Value.name
        try {
            Install-Module $name -Force
            Write-Log -Severity Information -logFile $logFile "Installed $name successfully"
        }
        catch {
            Write-Log -Severity Error -logFile $logFile -Message "Couldn't install package $name"
            Write-Log -Severity Error -logFile $logFile -Message $_.Exception.Message
            Exit 1001
        }
    }
}



Install-Packages -packageNameUrl https://raw.githubusercontent.com/damonbreeden/powershell-ITROnboarding/master/packageNames.json