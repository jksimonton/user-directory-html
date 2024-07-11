
function HTML-Blocks2 {
    [cmdletbinding()]
        param (
        $BlockName = "",
        $Username,
        $FilePath = "C:\ProjectData\user-directory-html\v2\index.html"
    )

$UserFullName = Get-ADUser $Username -Properties DisplayName | Select-Object -ExpandProperty DisplayName
$UserTitle = Get-ADUser $Username -Properties Title | Select-Object -ExpandProperty Title
$UserOffice = Get-ADUser $Username -Properties PhysicalDeliveryOfficeName | Select-Object -ExpandProperty PhysicalDeliveryOfficeName
$UserEmail = Get-ADUser $Username -Properties Mail | Select-Object -ExpandProperty Mail
$UserPhone = Get-ADUser $Username -Properties TelephoneNumber | Select-Object -ExpandProperty TelephoneNumber
$UserExt = Get-ADUser $Username -Properties ipPhone | Select-Object -ExpandProperty ipPhone

if ($UserOffice -eq $null) { $UserOffice = "N/A"}
if ($UserEmail -eq $null) { $UserEmail = "N/A"}
if ($UserPhone -eq $null) { $UserPhone = "N/A"}
if ($UserExt -eq $null) { $UserExt = "N/A"}

# Start and End of the HTML File
$indexstart = @("
<html>
<div class='directory'>
<div class='person'>
<div class='block' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
")

$indexend = @("
</div> <!-- End Root User -->
</div> <!-- End Directory -->
</html>
<style>
html {
    display: flex;
    text-align: center;
    font-family: sans-serif;
}
.directory {
    flex-grow: 1;
}
.person {
    flex-grow: 1;
}
.block {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    border: 1pt solid black;
    margin-left: 5pt;
    margin-right: 5pt;
}
.stackedblock {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
    border: 1pt solid black;
    margin-left: 0pt;
    margin-right: 10pt;
}
.block:hover,.stackedblock:hover { background-color: #dfecf5; }
.name {
    padding: 2pt;
    padding-bottom: 1pt;
    font-size: 1.6em;
    text-wrap: nowrap;
}
.title {
    padding: 2pt;
    padding-top: 1pt;
    font-size: 1.2em;
    font-style: italic;
}
.directreports {
    display: flex;
    flex-direction: row;
    justify-content: space-evenly;
}
.reportstack {
    display: flex;
    flex-direction: column;
    flex-grow: 1;
}
.stackedperson {
    display: flex;
    flex-direction: row;
}
.stackspacer {
    border-left: 1pt solid black;
    width: 0pt;
    height: 5pt;
}
.rowlines {
    display: flex;
    flex-direction: row;
}
.columnlines {
    display: flex;
    flex-direction: column;
}
.leftseparator {
    border-right: 1pt solid black;
    width: 50%;
    height: 10pt;
}
.middleseparator {
    border-right: 1pt solid black;
    width: 0pt;
    height: 10pt;
}
.rightseparator {
    border-left: 1pt solid black;
    width: 50%;
    height: 10pt;
}
.stackseparator {
    border-bottom: 1pt solid black;
    min-width: 10pt;
    height: 50%;
}
.leftconnector {
    border-top: 1pt solid black;

    width: 50%;
    height: 0pt;
}
.middleconnector {
    border-top: 1pt solid black;
    width: 100%;
    height: 0pt;
}
.rightconnector {
    border-top: 1pt solid black;
    width: 50%;
    height: 0pt;
}
.stackonlyconnector {
    border-top: 1pt solid black;
    border-left: 1pt solid black;
    width: 50%;
    height: 4pt;
}
.stackconnector {
    border-top: 1pt solid black;
    border-left: 1pt solid black;
    width: 100%;
    height: 4pt;
}
.middlestackconnector {
    border-left: 1pt solid black;
    width: 0pt;
    height: 100%;
}
.bottomstackconnector {
    border-left: 1pt solid black;
    border-bottom: 1pt solid black;
    width: 0pt;
    height: 50%;
}
[type='checkbox'] {
    position: absolute;
    left: -100vw;
}
.otherinfo { display: none; }
.otherinfo.expanded { display: block; }
.spacer { width: 100%; height: 3pt; }
</style>

<script>
    function toggleExpand(event, element) {

        event.preventDefault();

        let children = [];

        for (var i = 0; i < element.childNodes.length; i++) {
            if (element.childNodes[i].className == 'otherinfo') {
                children.push(element.childNodes[i]);
            }
            if (element.childNodes[i].className == 'otherinfo expanded') {
                children.push(element.childNodes[i]);
            }
        }

        children.forEach(child => {
            child.classList.toggle('expanded');
        });
    }
</script>
")


# Person Starts and Ends
$personLeft = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='leftseparator'></div>
<div class='leftconnector'></div>
</div>
<div class='block' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
")

$personMiddle = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='rightconnector'></div>
<div class='middleseparator'></div>
<div class='leftconnector'></div>
</div>
<div class='block' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
")

$personRight = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='rightconnector'></div>
<div class='rightseparator'></div>
</div>
<div class='block' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
")

$personOnly = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='leftseparator'></div>
<div class='block' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
")

$personEnd = @("</div> <!-- End $UserFullName Person -->")

# Person Stacks
$stackStartOnly = @("
<div class='reportstack'> <!-- Start Stack -->
<div class='stackonlyconnector'></div>
")

$stackStartOthers = @("
<div class='reportstack'> <!-- Start Stack -->
<div class='stackconnector'></div>
")

$stackedPerson = @("
<div class='stackspacer'></div>
<div class='stackedperson'> <!-- Start $UserFullName Stacked Person -->
<div class='middlestackconnector'></div>
<div class='stackseparator'></div>
<div class='stackedblock' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
</div> <!-- End $UserFullName Stacked Person -->
")

$stackedPersonBottom = @("
<div class='stackspacer'></div>
<div class='stackedperson'> <!-- Start $UserFullName Stacked Person -->
<div class='bottomstackconnector'></div>
<div class='stackseparator'></div>
<div class='stackedblock' onclick='toggleExpand(event, this)'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
<div class='otherinfo'>Office: $UserOffice</div>
<div class='otherinfo'>Email: $UserEmail</div>
<div class='otherinfo'>Phone: $UserPhone</div>
<div class='otherinfo'>Extension: $UserExt</div>
<div class='spacer'></div>
</div>
</div> <!-- End $UserFullName Stacked Person --> 
</div> <!-- End Stack -->
")

# Is a Manager
$managerStart = @("
<div class='leftseparator'></div>
<div class='directreports'> <!-- Start Direct Reports $UserFullName -->
")

$managerEnd = @("
</div> <!-- End Direct Reports $UserFullName -->
")


Switch ($BlockName) 
{
    "indexstart"          { Add-Content -Path $FilePath $indexstart          }
    "indexend"            { Add-Content -Path $FilePath $indexend            }
    "personleft"          { Add-Content -Path $FilePath $personLeft          }
    "personmiddle"        { Add-Content -Path $FilePath $personMiddle        }
    "personright"         { Add-Content -Path $FilePath $personRight         }
    "persononly"          { Add-Content -Path $FilePath $personOnly          }
    "personend"           { Add-Content -Path $FilePath $personEnd           }
    "stackstartonly"      { Add-Content -Path $FilePath $stackStartOnly      }
    "stackstartothers"    { Add-Content -Path $FilePath $stackStartOthers    }
    "stackedperson"       { Add-Content -Path $FilePath $stackedPerson       }
    "stackedpersonbottom" { Add-Content -Path $FilePath $stackedPersonBottom }
    "managerstart"        { Add-Content -Path $FilePath $managerStart        }
    "managerend"          { Add-Content -Path $FilePath $managerEnd          }
}

}