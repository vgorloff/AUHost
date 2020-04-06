#!/bin/bash

set -e
set -o pipefail

source $(dirname "$0")/common.sh

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)
cd "$SrcDirPath"

xcodebuild -project "$AppProjectFilePath" -scheme "AUHost" CODE_SIGNING_REQUIRED=NO CODE_SIGN_STYLE=Manual DEVELOPMENT_TEAM= CODE_SIGN_IDENTITY= build | xcpretty || exit 1

