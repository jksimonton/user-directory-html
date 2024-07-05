
Import-Module ActiveDirectory
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

function Get-UserDirectory {
    [cmdletBinding()]
    param (
        $Manager = "",
        $outputPath = "C:\ProjectOutput\Get-UserDirectory-HTML\index.html"
    )

    $scriptName = "Get-UserDirectory"

    if ($Manager -eq "") { $Manager = Read-Host "Root Manager Username" }

    try {
        $rootManagerName = Get-ADUser $Manager -Properties DisplayName | Select-Object -ExpandProperty DisplayName
        Write-Host "`nRoot Manager: $rootManagerName`n"
    } catch {
        Write-Host "`nInvalid Username or other issue locating user. Please Try Again.`n"
        Exit
    }

    HTML-Blocks "rootsetup" $rootManagerName $outputPath

    Get-DirectReports $Manager 0 $null $outputPath

    HTML-Blocks "rootend" $rootManagerName $outputPath

}