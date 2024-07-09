
Import-Module ActiveDirectory

function Get-DirectReports {
    [cmdletBinding()]
    param (
        $Manager = "",
        $Level = 0,
        $IncludeServiceAccounts = $null,
        $OutputPath = ""
    )

}