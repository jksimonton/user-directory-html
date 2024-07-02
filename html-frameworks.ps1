
function HTML-Blocks {
[cmdletbinding()]
    param (
    $BlockName = "",
    $UserFullName = "Name",
    $FilePath = "C:\ProjectData\user-directory-html\index.html"
)

#region Basic Blocks

$singleDiv = @("
</div>
")

$doubleDiv = @("
</div>
</div>
")

#endregion

#region Root Code

$rootSetup = @( "
<link href='style.css' rel='stylesheet' />

<div class='directory'>
<div class='root'>
<div class='name'>$UserFullName</div>
")

$rootEnding = $doubleDiv

#endregion


#region Is Manager

$isManager = @("
<div class='manager'></div>
<div class='directreports'>
")

$isManagerEnd  = $singleDiv

#endregion


#region Each Person

$personFirstReport = @("
<div class='person'>
<div class='personbefore'></div>
<div class='reportleft'></div>
<div class='name'>$UserFullName</div>
")

$personMiddleReport = @("
<div class='person'>
<div class='personbefore'></div>
<div class='reportcenter'></div>
<div class='name'>$UserFullName</div>
")

$personLastReport = @("
<div class='person'>
<div class='personbefore'></div>
<div class='reportright'></div>
<div class='name'>$UserFullName</div>
")

$personOnlyReport = @("
<div class='person'>
<div class='personbefore'></div>
<div class='name'>$UserFullName</div>
")  

$personEnd = $singleDiv

#endregion

if ($BlockName -eq "singlediv") { Add-Content -Path $FilePath $singleDiv }
elseif ($BlockName -eq "doublediv") { Add-Content -Path $FilePath $doubleDiv }
elseif ($BlockName -eq "rootsetup") { Add-Content -Path $FilePath $rootSetup }
elseif ($BlockName -eq "rootend") { Add-Content -Path $FilePath $rootEnding }
elseif ($BlockName -eq "ismanager") { Add-Content -Path $FilePath $isManager }
elseif ($BlockName -eq "ismanagerend") { Add-Content -Path $FilePath $isManagerEnd }
elseif ($BlockName -eq "personfirst") { Add-Content -Path $FilePath $personFirstReport }
elseif ($BlockName -eq "personmiddle") { Add-Content -Path $FilePath $personMiddleReport }
elseif ($BlockName -eq "personlast") { Add-Content -Path $FilePath $personLastReport }
elseif ($BlockName -eq "persononly") { Add-Content -Path $FilePath $personOnlyReport }
elseif ($BlockName -eq "personend") { Add-Content -Path $FilePath $personEnd }

}