#!/bin/bash

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

# npm install || exit 1
gem install xcpretty || exit 1
