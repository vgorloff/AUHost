#!/bin/bash

AWLProjectDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLProjectDirPath"

AWLSyncLeft="$AWLProjectDirPath/Vendor/WL"
AWLSyncRight="$GV_DEV_HOME/libs/WL"
open -b com.jetbrains.intellij.ce --args diff "$AWLSyncLeft" "$AWLSyncRight"
