#!/bin/bash -l

# Run in inly modified files: https://swifting.io/blog/2016/03/29/11-swiftlint/

if [ -n "$CLANG_COVERAGE_MAPPING" ]; then echo "Script skipped in testing mode." && exit 0; fi

[[ -r ~/.bashrc ]] && . ~/.bashrc # Or set /bin/bash -l as shell in Xcode
hash swiftlint 2>/dev/null || { echo "swiftlint does not exist. Solution: brew install swiftlint"; exit 0; }
for file_path in $@; do
	swiftlint lint --quiet --path $file_path
done