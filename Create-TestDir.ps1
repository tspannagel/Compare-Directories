Remove-Item .\CompareTest -Force -Recurse -ErrorAction SilentlyContinue

New-Item -Path .\CompareTest\P1 -ItemType Directory
New-Item -Path .\CompareTest\P2 -ItemType Directory

"TEST" | Out-File .\CompareTest\P1\test1.txt -Force
"TEST" | Out-File .\CompareTest\P2\test1.txt -Force

"TEST" | Out-File .\CompareTest\P1\test2.txt -Force
"TEST But Longer" | Out-File .\CompareTest\P2\test2.txt -Force

"Test" | Out-File .\CompareTest\P2\test3.txt -Force