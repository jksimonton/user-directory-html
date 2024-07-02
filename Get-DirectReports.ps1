
Import-Module ActiveDirectory

function Get-DirectReports {
    [cmdletBinding()]
    param (
        $Manager = "",
        $Level = 0,
        $IncludeServiceAccounts = $null,
        $OutputPath = ""
    )
    
    $dirtyReports = Get-ADUser -Identity $manager -Properties DirectReports | select-object -ExpandProperty DirectReports

    $cleanReports = @()

    if ($null -eq $IncludeServiceAccounts) { $includeServiceAccounts = Read-Host "Would you like to include Service Accounts? (y/n)" }

    foreach ($user in $dirtyReports) {
        $user = Get-ADUser -Identity $user | Select-Object -ExpandProperty samAccountName
        $userString = Out-String -InputObject $user
        
        if($userString -like "*_*" -and $IncludeServiceAccounts -eq "n"){}
        elseif($userString -like "*-*" -and $IncludeServiceAccounts -eq "n"){}
        elseif($userString -like "*#*" -and $IncludeServiceAccounts -eq "n"){}
        else
        {
            $cleanReports += $user
        }
    }

    if ($cleanReports.count -gt 0) { 
        
        $cleanReports = $cleanReports | Sort-Object

        # Get the Name of the current manager.
        $managerName = Get-ADUser -Identity $Manager -Properties DisplayName | Select-Object -ExpandProperty DisplayName

        HTML-Blocks "ismanager" $managerName $OutputPath

        #output the manager and their direct reports
        foreach ($user in $cleanReports) { $user = Get-ADUser -Identity $user | Select-Object -ExpandProperty samAccountName }
        
        $Level = $Level + 1

        foreach ($user in $cleanReports)
        {
            $UserFullName = Get-ADUser -Identity $user -Properties DisplayName | Select-Object -ExpandProperty DisplayName

            if ($cleanReports.Count -eq 1) { HTML-Blocks "persononly" $UserFullName $OutputPath }
            elseif ($user -eq $cleanReports[0]) { HTML-Blocks "personfirst" $UserFullName $OutputPath }
            elseif ($user -eq $cleanReports[$cleanReports.Length-1]) { HTML-Blocks "personlast" $UserFullName $OutputPath }
            else { HTML-Blocks "personmiddle" $UserFullName $OutputPath }

            Get-DirectReports $user $Level $IncludeServiceAccounts $OutputPath

            HTML-Blocks "personend" $UserFullName $OutputPath
        } 
        HTML-Blocks "ismanagerend" $managerName $OutputPath
    }


}