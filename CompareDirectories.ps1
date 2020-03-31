param(
    [Parameter(mandatory = $true)]
    [string] $CopyTo, #Path where directory should be copied to
    [string] $CopyFrom, #Path of the directory to copy
    [switch] $OutputMismatchOnly, #Don't show matching filenames
    [switch] $Merge, #copy files from "from" to "to" and append suffix if size differs
    [switch] $NoFileListsOutput #Dont't show any file lists in console   
)

$pathTo = $CopyTo
$pathFrom = $CopyFrom

$listTo = Get-ChildItem $pathTo 
$listFrom = Get-ChildItem $pathFrom 

$notInTo = New-Object System.Collections.ArrayList #Filenames not matched
$inTo = New-Object System.Collections.ArrayList #Filenames matched
$check = New-Object System.Collections.ArrayList #Filenames matched but different size


foreach ($itemFrom in $listFrom) {
    $matched = $false
    $sizeDiffers = $false

    foreach ($itemTo in $listTo) {
        
        if ($itemFrom.Name -eq $itemTo.Name) {
            $matched = $true        
            if ($itemFrom.Length -ne $itemTo.Length) {
                $sizeDiffers = $true            
            }    
        }

        if ($matched) {
            break
        }
    }

    if ($matched) {    
        if ($sizeDiffers) {
            $check.Add($itemFrom) | Out-Null
        }
        else {            
            $inTo.Add($itemFrom) | Out-Null
        }
    }
    else {
        $notInTo.Add($itemFrom) | Out-Null
    }

}

if (-Not $NoFileListsOutput) {
    if ($inTo.Count -gt 0 -and $OutputMismatchOnly) {
        "The following files are already in $pathTo :"
        foreach ($item in $inTo) {
            "`t" + $item.Fullname
        }
        "-------------------------------`n`n"
    }

    if ($check.Count -gt 0) {
        "The following files are already in $pathTo :`n But differs in size!"
        foreach ($item in $check) {
            "`t" + $check.FullName 
        }
        "-------------------------------`n`n"
    }

    if ($notInTo.Count -gt 0) {
        "The following files are not in $pathTo :"
        foreach ($item in $notInTo) {
            "`t" + $item.Fullname
        }
        "-------------------------------`n`n"
    }
}

#Move and evenutally rename files
if ($Merge) {

    foreach ($file in $notInTo) {

        Copy-Item -Path
    }
}