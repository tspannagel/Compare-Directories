.\Compare-Directories.ps1 -CopyTo .\CompareTest\P1 -CopyFrom .\CompareTest\P2
<#
Expected: 
test1.txt exists in both
test2.txt exists in both, differs in size
test3.txt is not in target
#>

.\Compare-Directories.ps1 -CopyTo .\CompareTest\P1 -CopyFrom .\CompareTest\P2 -NoFileListsOutput -Copy

<#
Expected:
test1.txt stays as-is 
test2.txt from p1 stays as-is 
new: test2_conflict.txt from p2 in p1
test3.txt from p2 in p1
#>

