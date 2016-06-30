#!/bin/bash
# Proper header for a Bash script.

AWLScriptDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLScriptDirPath"

/Applications/Tools/FreeFileSync.app/Contents/MacOS/FreeFileSync "$AWLScriptDirPath/.sync.ffs_gui" -Edit
