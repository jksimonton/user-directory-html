
Import-Module ActiveDirectory

function Get-DirectReports {
    [cmdletBinding()]
    param (
        $Manager = "",
        $Level = 0,
        $IncludeServiceAccounts = $null,
        $OutputPath = ""
    )

    $dirtyReports = @()
    
    $dirtyReports = Get-ADUser -Identity $manager -Properties DirectReports | select-object -ExpandProperty DirectReports

    $dirtyReports = $dirtyReports | Sort-Object

    $cleanReports = @()

    if ($null -eq $IncludeServiceAccounts) { $IncludeServiceAccounts = Read-Host "Would you like to include Service Accounts? (y/n)" }

    foreach ($user in $dirtyReports) {
        $user = Get-ADUser -Identity $user | Select-Object samAccountName
        #$userString = Out-String -InputObject $user.samAccountName
        
        #if($userString -like "*_*" -and $IncludeServiceAccounts -eq "n"){}
        #elseif($userString -like "*-*" -and $IncludeServiceAccounts -eq "n"){}
        #elseif($userString -like "*#*" -and $IncludeServiceAccounts -eq "n"){}
        #else
        
        $cleanReports = $cleanReports + $user
        
    }

    if ($cleanReports.Count -gt 0) { 

        # Get the Name of the current manager.
        $managerName = Get-ADUser -Identity $Manager -Properties DisplayName | Select-Object -ExpandProperty DisplayName

        HTML-Blocks "ismanager" $managerName $OutputPath
        
        $Level = $Level + 1

        $usersWithReports = @()
        $usersWithoutReports = @()

        if ($cleanReports.Count -gt 3) {
            foreach ($user in $cleanReports) {
                if((Get-ADUser $user.samAccountName -Properties DirectReports | Select-Object -ExpandProperty DirectReports).Count -gt 0) {
                    $usersWithReports = $usersWithReports + $user
                } else { $usersWithoutReports = $usersWithoutReports + $user }
            }

            if ($usersWithoutReports.Count -gt 2) {
                
                if ($usersWithReports.Count -eq 0 ) { HTML-Blocks "noreportsstartonly" $managerName $OutputPath }
                else { HTML-Blocks "noreportsstart" $managerName $OutputPath }

                foreach ($noReportUser in $usersWithoutReports) {
                    $noReportUserName = Get-ADUser $noReportUser.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName
                    HTML-Blocks "personstacked" $noReportUserName $OutputPath
                    if($noReportUser.samAccountName -ne $usersWithoutReports[$usersWithoutReports.Count-1].samAccountName) { HTML-Blocks "stackseparator" $noReportUserName $OutputPath }
                }
                HTML-Blocks "noreportsend" $managerName $OutputPath

                foreach ($yesReportUser in $usersWithReports)
                {
                    $ReportUserFullName = Get-ADUser -Identity $yesReportUser.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName

                    if ($cleanReports.Count -eq 1) { HTML-Blocks "persononly" $ReportUserFullName $OutputPath }
                    elseif ($yesReportUser.samAccountName -eq $usersWithReports[$usersWithReports.Count-1].samAccountName) { HTML-Blocks "personlast" $ReportUserFullName $OutputPath }
                    else { HTML-Blocks "personmiddle" $ReportUserFullName $OutputPath }

                    Get-DirectReports $yesReportUser.samAccountName $Level $IncludeServiceAccounts $OutputPath

                    HTML-Blocks "personend" $ReportUserFullName $OutputPath
                }
            } else {
                foreach ($user in $cleanReports) {
                    $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName

                    if ($cleanReports.Count -eq 1) { HTML-Blocks "persononly" $UserFullName $OutputPath }
                    elseif ($user.samAccountName -eq $cleanReports[0].samAccountName) { HTML-Blocks "personfirst" $UserFullName $OutputPath }
                    elseif ($user.samAccountName -eq $cleanReports[$cleanReports.Count-1].samAccountName) { HTML-Blocks "personlast" $UserFullName $OutputPath }
                    else { HTML-Blocks "personmiddle" $UserFullName $OutputPath }

                    Get-DirectReports $user.samAccountName $Level $IncludeServiceAccounts $OutputPath

                    HTML-Blocks "personend" $UserFullName $OutputPath
                }
            }
        } else {

            foreach ($user in $cleanReports)
            {
                $UserFullName = Get-ADUser -Identity $user.samAccountName -Properties DisplayName | Select-Object -ExpandProperty DisplayName

                if ($cleanReports.Count -eq 1) { HTML-Blocks "persononly" $UserFullName $OutputPath }
                elseif ($user -eq $cleanReports[0]) { HTML-Blocks "personfirst" $UserFullName $OutputPath }
                elseif ($user -eq $cleanReports[$cleanReports.Length-1]) { HTML-Blocks "personlast" $UserFullName $OutputPath }
                else { HTML-Blocks "personmiddle" $UserFullName $OutputPath }

                Get-DirectReports $user.samAccountName $Level $IncludeServiceAccounts $OutputPath

                HTML-Blocks "personend" $UserFullName $OutputPath
            } 
        }

        HTML-Blocks "ismanagerend" $managerName $OutputPath
    }


}