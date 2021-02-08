#!/bin/bash

set -e
set -o pipefail

source $(dirname "$0")/common.sh

xcodebuild -project "$AppProjectFilePath" -scheme "$AppSchema" -archivePath "$AppArchiveRoot" archive -arch x86_64 -arch arm64 ONLY_ACTIVE_ARCH=NO DEVELOPMENT_TEAM=H3M62US4J7 CODE_SIGN_IDENTITY="Developer ID Application" | xcpretty
