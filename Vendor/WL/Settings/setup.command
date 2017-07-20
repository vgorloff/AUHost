#!/bin/bash
# Proper header for a Bash script.

AWLSrcDirPath=$(cd "$(dirname "$0")/../../../"; pwd)
cd "$AWLSrcDirPath"

ln -sfv  "Vendor/WL/Settings/gitignore" ".gitignore"
ln -sfv  "Vendor/WL/Settings/swiftlint.yml" ".swiftlint.yml"
ln -sfv  "Vendor/WL/Settings/travis.yml" ".travis.yml"
ln -sfv  "Vendor/WL/Settings/LICENSE" "LICENSE"

sleep 2