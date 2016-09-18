#!/bin/bash

AWLSrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$AWLSrcDirPath"

"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_SwiftLint.sh" "$AWLSrcDirPath"
"$AWLSrcDirPath/Shared/Conf/Scripts/BuildPhase_CheckHeaders.sh" "WaveLabs" "$AWLSrcDirPath/Tests" "$AWLSrcDirPath/Shared" "$AWLSrcDirPath/Sources"
