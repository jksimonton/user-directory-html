
Import-Module ActiveDirectory

function Get-DirectReports2 {
    [cmdletBinding()]
    param (
        $Manager = "",
        $Level = 0,
        $IncludeServiceAccounts = $null,
        $OutputPath = ""
    )

    if ($null -eq $IncludeServiceAccounts) { $IncludeServiceAccounts = Read-Host "Would you like to include Service Accounts? (y/n)" }

    $dirtyReports = @()
    $cleanReports = @()

    $ManagerFullName = Get-ADUser -Identity $Manager -Properties DisplayName | Select-Object -ExpandProperty DisplayName
    $ManagerTitle = Get-ADUser -Identity $Manager -Properties Title | Select-Object -ExpandProperty Title

    $dirtyReports = Get-ADUser -Identity $Manager -Properties DirectReports | select-object -ExpandProperty DirectReports

    $dirtyReports = $dirtyReports | Sort-Object

    foreach ($user in $dirtyReports) {
        $user = Get-ADUser -Identity $user | Select-Object samAccountName
        if ($IncludeServiceAccounts -eq "n") {
            $userString = Out-String -InputObject $user.samAccountName

            if($userString -like "*_*"){}
            elseif($userString -like "*-*"){}
            elseif($userString -like "*#*"){}
            else { $cleanReports = $cleanReports + $user }

        } else { $cleanReports = $cleanReports + $user }
    }

    if ($cleanReports.Count -gt 0) { # If the current user actually has direct reports.
        HTML-Blocks2 "managerstart" $ManagerFullName $ManagerTitle $OutputPath
        if ($cleanReports.Count -eq 1) {
            foreach ($user in $cleanReports) {
                $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                HTML-Blocks2 "persononly" $UserFullName $UserTitle $OutputPath
                Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
            }
        } elseif ($cleanReports.Count -gt 3) { # If there are more than 3 direct reports under the manager, they may qualify for stacking.
            $noReports = @()
            $yesReports = @()

            foreach ($user in $cleanReports) {
                $reportsTest = $false
                $reportsTest = Clear-DirectReports $user.samAccountName $IncludeServiceAccounts

                if ($reportsTest -eq $true) { $yesReports = $yesReports + $user }
                else { $noReports = $noReports + $user }
            }

            $yesReports = $yesReports | Sort-Object
            $noReports = $noReports | Sort-Object

            if ($yesReports.Count -gt 0) { # If the user's direct reports also have direct reports.
                if ($noReports.Count -gt 3) { # If there are more than three users without direct reports, stack them and then list the others.
                    HTML-Blocks2 "stackstartothers" $ManagerFullName $ManagerTitle $OutputPath
                    foreach ($user in $noReports) {
                        $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                        $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                        if ($user -eq $noReports[$noReports.Count-1]) { HTML-Blocks2 "stackedpersonbottom" $UserFullName $UserTitle $OutputPath }
                        else { HTML-Blocks2 "stackedperson" $UserFullName $UserTitle $OutputPath }
                    }
                    foreach ($user in $yesReports) {
                        $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                        $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                        if ($user -eq $yesReports[$yesReports.Count-1]) { HTML-Blocks2 "personright" $UserFullName $UserTitle $OutputPath }
                        else { HTML-Blocks2 "personmiddle" $UserFullName $UserTitle $OutputPath }
                        Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                        HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                    }
                } else { # There aren't enough no reports users to bother with a stack.
                    foreach ($user in $cleanReports) {
                        $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                        $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                        if ($user -eq $cleanReports[0]) {
                            HTML-Blocks2 "personleft" $UserFullName $UserTitle $OutputPath
                            Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                            HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                        } elseif ($user -eq $cleanReports[$cleanReports.Count-1]) {
                            HTML-Blocks2 "personright" $UserFullName $UserTitle $OutputPath
                            Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                            HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                        } else {
                            HTML-Blocks2 "personmiddle" $UserFullName $UserTitle $OutputPath
                            Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                            HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                        }
                    }
                }
            } else { # No direct reports after the current user, just stack them all.
                HTML-Blocks2 "stackstartonly" $ManagerFullName $ManagerTitle $OutputPath
                foreach ($user in $cleanReports) {
                    $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                    $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                    if ($user -eq $cleanReports[$cleanReports.Count-1]) { HTML-Blocks2 "stackedpersonbottom" $UserFullName $UserTitle $OutputPath}
                    else { HTML-Blocks2 "stackedperson" $UserFullName $UserTitle $OutputPath }
                }
            }
        } else {
            foreach ($user in $cleanReports) {
                $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                $UserTitle = Get-ADUser -Identity $user.samAccountName -Properties Title | Select-Object -ExpandProperty Title
                if ($user -eq $cleanReports[0]) {
                    HTML-Blocks2 "personleft" $UserFullName $UserTitle $OutputPath
                    Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                    HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                } elseif ($user -eq $cleanReports[$cleanReports.Count-1]) {
                    HTML-Blocks2 "personright" $UserFullName $UserTitle $OutputPath
                    Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                    HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                } else {
                    HTML-Blocks2 "personmiddle" $UserFullName $UserTitle $OutputPath
                    Get-DirectReports2 $user.samAccountName $Level $IncludeServiceAccounts $OutputPath
                    HTML-Blocks2 "personend" $UserFullName $UserTitle $OutputPath
                }
            }
        }
        HTML-Blocks2 "managerend" $ManagerFullName $ManagerTitle $OutputPath
    }
}