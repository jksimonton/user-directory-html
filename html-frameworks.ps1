
#region Basic Blocks

$singleDiv = @("
</div>
</div>
")

$doubleDiv = @("
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

$isManagerEnd  = $doubleDiv

#endregion


#region Each Person

$personFirstReport = @("
<div class='person'>
<div class='reportleft'></div>
<div class='name'>$UserFullName</div>
")

$personMiddleReport = @("
<div class='person'>
<div class='reportcenter'></div>
<div class='name'>$UserFullName</div>
")

$personLastReport = @("
<div class='person'>
<div class='reportright'></div>
<div class='name'>$UserFullName</div>
")

$personOnlyReport = @("
<div class='person'>
<div class='name'>$UserFullName</div>
")  

$personEnd = $singleDiv

#endregion