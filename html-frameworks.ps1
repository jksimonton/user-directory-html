
#region Root Code

$rootSetup = @( "
<link href='style.css' rel='stylesheet' />

<div class='directory'>
<div class='root'>
<div class='name'>$UserFullName</div>
")

$rootEnding = @( "
</div>
</div>
")

#endregion


#region Is Manager

$isManager = @("
<div class='manager'></div>
<div class='directreports'>
")

$isManagerEnd  = @("
</div>
</div>
")

#endregion