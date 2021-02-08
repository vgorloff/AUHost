#!/bin/bash

SrcDirPath=$(cd "$(dirname "$0")/../"; pwd)

AppProjectFilePath=$SrcDirPath/AUHost.xcodeproj
AppBuildRoot=$SrcDirPath/Build
AppArchiveRoot=$AppBuildRoot/AUHost.xcarchive
AppSchema=AUHost
