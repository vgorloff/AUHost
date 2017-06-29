#!/bin/bash
# Proper header for a Bash script.

AWLProjectDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLProjectDirPath"

AWLExeFilePath="/Applications/Tools/FreeFileSync.app/Contents/MacOS/FreeFileSync"
AWLSyncLeft="$AWLProjectDirPath/Vendor/WL"
AWLSyncRight="$GV_DEV_HOME/libs/WL"
"$AWLExeFilePath" "$AWLSyncLeft/Conf/Settings/sync.ffs_gui" -LeftDir "$AWLSyncLeft" -RightDir "$AWLSyncRight"
