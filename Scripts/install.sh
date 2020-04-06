#!/bin/bash

set -e
set -o pipefail

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

npm install || exit 1
gem install xcpretty || exit 1
