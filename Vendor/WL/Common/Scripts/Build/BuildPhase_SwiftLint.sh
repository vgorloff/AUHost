#!/bin/bash
# File: BuildPhase_SwiftLint.sh

# swiftlint autocorrect --config "$2" --path "$1" 2>/dev/null
swiftlint lint --config "$2" --path "$1" 2>/dev/null
