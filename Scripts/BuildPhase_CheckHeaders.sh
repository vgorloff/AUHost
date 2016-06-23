#!/bin/bash -l

[[ -r ~/.bashrc ]] && . ~/.bashrc # Or set /bin/bash -l as shell in Xcode
hash swift-osx 2>/dev/null || { echo "swift-osx does not exist. Skipping."; exit 0; }

AWLScriptDirPath=$(cd "$(dirname "$0")"; pwd)
AWLScriptName="$(echo `basename $0` | cut -f 1 -d '.').swiftcmd"

"$AWLScriptDirPath/$AWLScriptName" $@