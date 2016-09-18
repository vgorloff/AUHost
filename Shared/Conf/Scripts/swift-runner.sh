#!/bin/bash

WLOSXSDKPath=`xcodebuild -version -sdk macosx Path`

#======================================
# Compile and run
#======================================
# SeeAlso: [ swiftly/swiftly at master · alphabetum/swiftly ]( https://github.com/alphabetum/swiftly/blob/master/swiftly )
WLThisScriptPath="$0"
WLCacheDirectoryPath="$1"
WLScriptFilePath="$2"
WLScriptArguments=${*:3}
WLScriptBaseName=$(basename "$WLScriptFilePath")
WLSwiftVersion=`echo $(swift --version) | awk '{print tolower($0)}' | tr "(): /.~" _`
WLBinaryName=`echo "$WLScriptBaseName" | awk '{print tolower($0)}' | tr "/.~" _`
WLBinaryFilePath="${WLCacheDirectoryPath}/${WLSwiftVersion}_${WLBinaryName}"

# echo $WLThisScriptPath
# echo $WLWLCacheDirectoryPath
# echo $WLScriptFilePath
# echo $WLScriptArguments
# echo $WLBinaryFilePath
#
# exit 0
#======================================

function compile {
	#echo "==> Compiling"
   ### Create the binary if it doesn't exist.
   [[ -x "$WLBinaryFilePath" ]] && rm -f "$WLBinaryFilePath"
   # [[ ! -d "$WLProcessedSourceDirPath" ]] &&  mkdir -p "$WLProcessedSourceDirPath"
   ### Special trick to support "rewrite" value of Process.arguments[0].
   # echo -e "ProcessInfo.processInfo.scriptFilePath = \"$WLScriptFilePath\"" > "$WLProcessedSourceFilePath"
   # sed '/^#/d' "$WLScriptFilePath" >> "$WLProcessedSourceFilePath"
   ### See Also (about -rpath) [ Run-Path Dependent Libraries ]( https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/DynamicLibraries/100-Articles/RunpathDependentLibraries.html )
   # xcrun swiftc -target x86_64-apple-macosx10.11 -sdk $WLOSXSDKPath -whole-module-optimization -module-name main -O -o "$WLBinaryFilePath" "$WLProcessedSourceFilePath"
   xcrun swiftc -target x86_64-apple-macosx10.11 -sdk $WLOSXSDKPath -whole-module-optimization -module-name main -O -o "$WLBinaryFilePath" "$WLScriptFilePath"
   # rm -rf "$WLProcessedSourceDirPath"
}

function launch {
	#echo "==> Launching"
	[[ -x "$WLBinaryFilePath" ]] && "$WLBinaryFilePath" $WLScriptArguments
}

function clear {
	#echo "==> Clearing"
	rm -rdf "$WLCacheDirectoryPath/"*
   # rm -rdf "$WLTmpDirectoryPath/"*
}

#======================================

[[ ! -d "$WLCacheDirectoryPath" ]] && mkdir -p "$WLCacheDirectoryPath"

if [ -x "$WLBinaryFilePath" ]; then
	if [ "$WLThisScriptPath" -nt "$WLBinaryFilePath" ]; then
		clear
	fi
	if [ "$WLBinaryFilePath" -nt "$WLScriptFilePath" ]; then
		launch
	else
		compile
		launch
	fi
else
	compile
	launch
fi
