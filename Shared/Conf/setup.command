#!/bin/bash
# Proper header for a Bash script.

AWLSrcDirPath=$(cd "$(dirname "$0")/../../"; pwd)
cd "$AWLSrcDirPath"

ln -sfv  "Shared/Conf/Settings/gitignore" ".gitignore"
ln -sfv  "Shared/Conf/Settings/swiftlint.yml" ".swiftlint.yml"
ln -sfv  "Shared/Conf/Settings/travis.yml" ".travis.yml"
ln -sfv  "Shared/Conf/LICENSE" "LICENSE"