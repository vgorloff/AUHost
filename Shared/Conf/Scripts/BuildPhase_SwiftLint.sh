#!/bin/bash -l

# Run in only modified files: https://swifting.io/blog/2016/03/29/11-swiftlint/

AWLSwiftLintConfigDirPath=$(cd "$(dirname "$0")/../Settings"; pwd)

if [ -n "$AWLSkipBuildScripts" ]; then echo "Script skipped by environment variable." && exit 0; fi
if [ -n "$CLANG_COVERAGE_MAPPING" ]; then echo "Script \"$0\" skipped in testing mode." && exit 0; fi
if [[ ${BUILT_PRODUCTS_DIR} == *"IBDesignables"* ]]; then echo "Script \"$0\" skipped in IBDesignables mode." && exit 0; fi

[[ -r ~/.bashrc ]] && . ~/.bashrc # Or set /bin/bash -l as shell in Xcode
hash swiftlint 2>/dev/null || { echo "swiftlint does not exist. Solution: brew install swiftlint"; exit 0; }
for file_path in $@; do
	swiftlint lint --quiet --config "$AWLSwiftLintConfigDirPath/swiftlint.yml" --path ${file_path}
done
