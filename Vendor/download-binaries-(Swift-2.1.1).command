#!/bin/bash
# Proper header for a Bash script.

AWLScriptDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLScriptDirPath"

AWLReleaseVersion=1.0.3
AWLBinaryArchiveName=WL.framework.zip
AWLBinaryArchivePath=$AWLScriptDirPath/$AWLBinaryArchiveName
curl -L https://github.com/vgorloff/WL/releases/download/$AWLReleaseVersion/$AWLBinaryArchiveName > "$AWLBinaryArchivePath" \
	&& rm -rv "$AWLScriptDirPath/WL" \
	&& unzip "$AWLBinaryArchivePath" \
	&& rm -v "$AWLBinaryArchivePath"
