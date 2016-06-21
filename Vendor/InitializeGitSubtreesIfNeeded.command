#!/bin/bash
# Proper header for a Bash script.

AWLSrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$AWLSrcDirPath"

function AWLCheckFolderAndReportWarning {
	if [ ! -d "Vendor/$1" ]; then
		echo "warning: Vendor/$1 does NOT exists. Please read file Readme.md"
		git subtree add --prefix Vendor/$1 https://github.com/vgorloff/$1.git master --squash
	fi
}

AWLCheckFolderAndReportWarning "WLCoreOpen"
AWLCheckFolderAndReportWarning "WLMediaOpen"
AWLCheckFolderAndReportWarning "WLUIOpen"
