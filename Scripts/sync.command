#!/bin/bash
# Proper header for a Bash script.

AWLProjectDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$AWLProjectDirPath"
export AWLSyncLeft="$AWLProjectDirPath/Shared"
export AWLSyncRight="$GV_VCS_HOME/BitBucket/WL"
/Applications/Tools/FreeFileSync.app/Contents/MacOS/FreeFileSync "$AWLSyncLeft/Conf/Settings/sync.ffs_gui" -LeftDir "$AWLSyncLeft" -RightDir "$AWLSyncRight"
# diffmerge "$AWLSyncLeft" "$AWLSyncRight"
# /Applications/Developer/Meld.app/Contents/MacOS/Meld "$AWLSyncLeft" "$AWLSyncRight"
