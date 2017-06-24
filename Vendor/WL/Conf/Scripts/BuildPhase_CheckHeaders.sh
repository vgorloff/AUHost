#!/bin/bash -l

# Run in only modified files: https://swifting.io/blog/2016/03/29/11-swiftlint/

if [ -n "$AWLSkipBuildScripts" ]; then echo "Script skipped by environment variable." && exit 0; fi
if [ -n "$CLANG_COVERAGE_MAPPING" ]; then echo "Script \"$0\" skipped in testing mode." && exit 0; fi
if [[ ${BUILT_PRODUCTS_DIR} == *"IBDesignables"* ]]; then echo "Script \"$0\" skipped in IBDesignables mode." && exit 0; fi

AWLScriptDirPath=$(cd "$(dirname "$0")"; pwd)
AWLScriptName="$(echo `basename $0` | cut -f 1 -d '.')"
AWLSourcesDirPath=$(cd "$(dirname "$0")/../../"; pwd)
AWLProjectRootDirPath=$(cd "$(dirname "$0")/../../../"; pwd)
AWLCacheDir="$AWLProjectRootDirPath/.tmp"

[[ ! -d "$AWLCacheDir" ]] && mkdir -p "$AWLCacheDir"
AWLOutputFilePath="${AWLCacheDir}/$AWLScriptName.swiftcmd"
if [ ! -f "$AWLOutputFilePath" ]; then
   cat "$AWLSourcesDirPath/Core/FoundationExtensions.swift" \
       "$AWLSourcesDirPath/Core/SwiftExtensions.swift" \
       "$AWLSourcesDirPath/Automation/FileHeaderChecker.swift" \
       "$AWLScriptDirPath/$AWLScriptName.swift" > "$AWLOutputFilePath"
fi

bash "$AWLScriptDirPath/swift-runner.sh" "$AWLCacheDir" "$AWLOutputFilePath" $@
# xcrun swift -target x86_64-macosx10.11 -sdk "`xcodebuild -version -sdk macosx Path`" "$AWLOutputFilePath"
# xcrun --sdk macosx swift -target x86_64-macosx10.11 "$AWLOutputFilePath"

# rm "$AWLOutputFilePath"