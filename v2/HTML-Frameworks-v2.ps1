
function HTML-Blocks2 {
    [cmdletbinding()]
        param (
        $BlockName = "",
        $UserFullName = "Name",
        $UserTitle = "Title",
        $FilePath = "C:\ProjectData\user-directory-html\v2\index.html"
    )

# Start and End of the HTML File
$indexstart = @("
<html>
<link href='v2-style.css' rel='stylesheet' />
<div class='directory'>
<div class='person'>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
</div>
")

$indexend = @("
</div> <!-- End Root User -->
</div> <!-- End Directory -->
</html>
")


# Person Starts and Ends
$personLeft = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='leftseparator'></div>
<div class='leftconnector'></div>
</div>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
</div>
")

$personMiddle = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='rightconnector'></div>
<div class='middleseparator'></div>
<div class='leftconnector'></div>
</div>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
</div>
")

$personRight = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='rowlines'>
<div class='rightconnector'></div>
<div class='rightseparator'></div>
</div>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
</div>
")

$personOnly = @("
<div class='person'> <!-- Start $UserFullName Person -->
<div class='leftseparator'></div>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
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
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
</div>
</div> <!-- End $UserFullName Stacked Person -->
")

$stackedPersonBottom = @("
<div class='stackspacer'></div>
<div class='stackedperson'> <!-- Start $UserFullName Stacked Person -->
<div class='bottomstackconnector'></div>
<div class='stackseparator'></div>
<div class='block'>
<div class='name'>$UserFullName</div>
<div class='title'>$UserTitle</div>
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