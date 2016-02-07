#!/bin/bash
# Proper header for a Bash script.

AWLScriptDirPath=$(cd "$(dirname "$0")"; pwd)
cd "$AWLScriptDirPath"
AWLGitDir=$(cd "$AWLScriptDirPath/WL"; pwd)

git rm --cached -r $AWLGitDir/
git add -v -f $AWLGitDir/Common
git add -v -f $AWLGitDir/Core
git add -v -f $AWLGitDir/Media
git add -v -f $AWLGitDir/UI
git rm --cached -r $AWLGitDir/\*.DS_Store
git rm --cached -r $AWLGitDir/\*/xcuserdata/\*