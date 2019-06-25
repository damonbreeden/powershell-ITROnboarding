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

function Initialize-LogDirectory {
    [CmdletBinding()]
        param (
            [string]$rootDir = "C:\ITresources",
            [string]$logDir = "logs"
        )

    $fullLogDir = "$rootDir\$logDir"
    If (!(Test-Path -LiteralPath $fullLogDir)) {
        try {
            New-Item -Path $fullLogDir -ItemType Directory -Force -ErrorAction Stop
            }
        catch {
            Write-Log -Severity Error -Message "Couldn't create directory"
            Write-Log -Severity Error -Message  $_.Exception.Message
            exit 1001
        }
    }
    <#
    .SYNOPSIS
        This script checks and creates a log directory
    .PARAMETER rootDir
        The root directory
    .PARAMETER logDir
        The name of the log dir (inside the rootDir)
    .EXAMPLE
        Initialize-LogDirectory -rootDir "C:\ITresources" -logDir "logs"
    .NOTES
        Author: Damon Breeden
        Github: https://github.com/damonbreeden
    #>

}

Initialize-LogDirectory