
Import-Module ActiveDirectory

function Clear-DirectReports {
    [cmdletBinding()]
    param (
        $Username,
        $IncludeServiceAccounts
    )

    $userReports = Get-ADUser -Identity $Username -Properties DirectReports | select-object -ExpandProperty DirectReports

    $Reports = @()

    foreach ($user in $userReports) {
        $user = Get-ADUser -Identity $user | Select-Object samAccountName
        if ($IncludeServiceAccounts -eq "n") {
            $userString = Out-String -InputObject $user.samAccountName

            if($userString -like "*_*"){}
            elseif($userString -like "*-*"){}
            elseif($userString -like "*#*"){}
            else { $Reports = $Reports + $user }

        } else { $Reports = $Reports + $user }
    }

    if ($Reports.Count -gt 0) { return $true }
    else { return $false }
}