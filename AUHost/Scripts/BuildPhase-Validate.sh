#!/bin/bash

AWLSrcDirPath=$(cd "$(dirname "$0")/../../"; pwd)
cd "$AWLSrcDirPath"

"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_SwiftLint.sh" "$AWLSrcDirPath/AUHost"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_SwiftLint.sh" "$AWLSrcDirPath/Shared"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_CheckHeaders.sh" "AUHost" "$AWLSrcDirPath/AUHost"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_CheckHeaders.sh" "WaveLabs" "$AWLSrcDirPath/Shared"