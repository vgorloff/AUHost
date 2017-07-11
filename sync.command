#!/bin/bash
# Proper header for a Bash script.

AWLProjectDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLProjectDirPath"

AWLSyncLeft="$AWLProjectDirPath/Vendor/WL"
AWLSyncRight="$GV_DEV_HOME/libs/WL"
open -W -b com.jetbrains.intellij.ce --args diff "$AWLSyncLeft" "$AWLSyncRight"
