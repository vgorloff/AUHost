#!/bin/bash

AWLSrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$AWLSrcDirPath"

"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_SwiftLint.sh" "$SRCROOT/AUHost"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_SwiftLint.sh" "$SRCROOT/Shared"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_CheckHeaders.sh" "AUHost" "$SRCROOT/AUHost"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_CheckHeaders.sh" "WaveLabs" "$SRCROOT/Shared"