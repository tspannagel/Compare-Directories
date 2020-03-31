param(
    [Parameter(Mandatory=$true)]
    [string] $CopyTo, #Path where directory should be copied to
    [Parameter(Mandatory=$true)]
    [string] $CopyFrom, #Path of the directory to copy
    [switch] $OutputMismatchOnly, #Don't show matching filenames
    [switch] $Copy, #copy files from "from" to "to" and append suffix if size differs
    [switch] $NoFileListsOutput, #Dont't show any file lists in console 
    [switch] $Move, #move files instead of copy  
    [string] $ConflictSuffix, #Suffix to append on files with same name, different sizes
    [switch] $OverWriteAll #Copies/Moves all files and overwrites conflicts
)

if($copy -and $move){
    "Contradicting parameters '-Copy' and '-Move' only one action can be performed"
    "Exiting..."
    exit 
}

$pathTo = $CopyTo
$pathFrom = $CopyFrom

$listTo = Get-ChildItem $pathTo -File
$listFrom = Get-ChildItem $pathFrom -File

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
    if ($inTo.Count -gt 0 -and -not $OutputMismatchOnly) {
        "The following files are already in $pathTo"
        foreach ($item in $inTo) {
            "`t" + $item.Fullname
        }
        "-------------------------------`n`n"
    }

    if ($check.Count -gt 0) {
        "The following files differ in size!`n "
        foreach ($item in $check) {
            "`t" + $check.FullName 
        }
        "-------------------------------`n`n"
    }

    if ($notInTo.Count -gt 0) {
        "The following files are not in $pathTo"
        foreach ($item in $notInTo) {
            "`t" + $item.Fullname
        }
        "-------------------------------`n`n"
    }
}

#Move and eventually rename files
if ($Copy -Or $Move) {

    #default suffix
    $suffix = "_conflict"

    #replace if provided
    if ([String]::IsNullOrEmpty($ConflictSuffix)) {
        $suffix = $ConflictSuffix
    }
    
    #Copy Files not in target
    foreach ($file in $notInTo) {

        $destination = Join-Path $pathTo $file.Name

        if ($Move) {            
            Move-Item -Path $file.Fullname -Destination $destination
        }
        else {
            Copy-Item -Path $file.Fullname -Destination $destination
        }
    }

    if ($OverWriteAll) {
        #Copy Files in target
        foreach ($file in $inTo) {

            $destination = Join-Path $pathTo $file.Name

            if ($Move) {            
                Move-Item -Path $file.Fullname -Destination $destination -Force
            }
            else {
                Copy-Item -Path $file.Fullname -Destination $destination -Force
            }
        }
        #Copy files in target but with different size
        foreach ($file in $check) {

            $destination = Join-Path $pathTo $file.Name
    
            if ($Move) {
                Move-Item -Path $file.Fullname -Destination $destination -Force
            }
            else {
                Copy-Item -Path $file.Fullname -Destination $destination -Force
            }
        }
    }
    else {
        #Copy files in target but with different size
        foreach ($file in $check) {

            $conflictFileName = $file.Name.ToString().Split(".")[0] + $suffix + $file.Name.ToString().Split(".")[1]
            $destination = Join-Path $pathTo $conflictFileName 

            if ($Move) {
                Move-Item -Path $file.Fullname -Destination $destination
            }
            else {
                Copy-Item -Path $file.Fullname -Destination $destination
            }
        }
    }
}