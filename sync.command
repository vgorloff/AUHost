#!/bin/bash
# Proper header for a Bash script.

AWLProjectDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLProjectDirPath"
AWLSyncLeft="$AWLProjectDirPath/Shared"
AWLSyncRight="$GV_VCS_HOME/BitBucket/WL"
/Applications/Tools/FreeFileSync.app/Contents/MacOS/FreeFileSync "$AWLSyncLeft/Conf/Settings/sync.ffs_gui" -LeftDir "$AWLSyncLeft" -RightDir "$AWLSyncRight"
