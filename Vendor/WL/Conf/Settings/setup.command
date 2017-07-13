#!/bin/bash
# Proper header for a Bash script.

AWLSrcDirPath=$(cd "$(dirname "$0")/../../../../"; pwd)
cd "$AWLSrcDirPath"

ln -sfv  "Vendor/WL/Conf/Settings/gitignore" ".gitignore"
ln -sfv  "Vendor/WL/Conf/Settings/swiftlint.yml" ".swiftlint.yml"
ln -sfv  "Vendor/WL/Conf/Settings/travis.yml" ".travis.yml"
ln -sfv  "Vendor/WL/Conf/Settings/LICENSE" "LICENSE"

sleep 2