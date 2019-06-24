function Initialize-LogDirectory {
    <#
        .SYNOPSIS
            This script checks and creates a log directory
        .PARAMETER rootDir
            The root directory
        .PARAMETER logDir
            The name of the log dir (inside the rootDir)
        .EXAMPLE
            Create-LogDirectory -rootDir "C:\ITresources" -logDir "logs"
        .NOTES
            Author: Damon Breeden
            Github: https://github.com/damonbreeden
        #>

    [CmdletBinding()]
        param (
            [string]$rootDir = "C:\ITresources",
            [string]$logDir = "logs"
        )

    $fullLogDir = "$rootDir\$logDir"
    If (!(Test-Path -LiteralPath $fullLogDir)) {
        New-Item -Path $fullLogDir -ItemType Directory -Force
        }

}

Initialize-LogDirectory