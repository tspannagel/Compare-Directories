# DirComp
Compare and merge directories. Use at own risk!

## Usage
Provide only CopyTo and CopyFrom to simply compare the directories

```Console
.\CompareDirectories.ps1 -CopyTo C:\temp\target -CopyFrom C:\temp\source 
```

### Parameters


- **-CopyTo** Mandatory, [string] <p>Path of the directory you want to compare with or move/copy files to</p>
- **-CopyFrom** Mandatory, [string] <p>Path of the directory you want to compare with or move/copy files from</p>
- **-OutputMismatchOnly** Optional, [switch] <p>Only output filenames that don't match (including differing sizes)</p>
- **-NoFileListsOutput** Optional, [switch] <p>Don't output any file list in console</p>
- **-Copy** Optional, [switch]<p>Copy the files not found in target. If different sizes are found, a suffix is added.</p>
- **-ConflictSuffix** Optional, [string] <p>Suffix to append on files with the same name but different sizes</p>

- **-Move** Optional, [switch] <p>#move files instead of copy  </p>
- **-OverWriteAll** Optional, [switch]<p>#Copies/Moves all files and overwrites conflicts</p>