
Import-Module ActiveDirectory

function Get-UserDirectory2 {
    [cmdletBinding()]
    param (
        $Manager = "",
        $outputPath = "C:\ProjectOutput\Get-UserDirectory-HTML\2\index.html"
    )

    if ($Manager -eq "") { $Manager = Read-Host "Input Root Manager"}

    try {
        $rootManagerName = Get-ADUser $Manager -Properties DisplayName | Select-Object -ExpandProperty DisplayName
        Write-Host "`nRoot Manager: $rootManagerName`n"
    } catch {
        Write-Host "`nInvalid Username or other issue locating user. Please Try Again.`n"
        Exit
    }

    HTML-Blocks2 "indexstart" $rootManagerName $rootManagerTitle $outputPath

    Get-DirectReports $Manager 0 $null $outputPath

    HTML-Blocks2 "indexend" $rootManagerName $rootManagerTitle $outputPath
}