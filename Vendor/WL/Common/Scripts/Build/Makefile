.PHONY: report default

WLIsUnderTesting=$(CLANG_COVERAGE_MAPPING)
WLSourcesDirectoryPath=$(SRCROOT)
WLBuildPhaseCheckHeadersScriptPath=$(SRCROOT)/Common/Scripts/Build/BuildPhase_CheckHeaders.swiftcmd
WLBuildPhaseSwiftLintScriptPath=$(SRCROOT)/Common/Scripts/Build/BuildPhase_SwiftLint.sh

WLBuildToolNameSwiftLint = swiftlint
ifneq ($(shell hash $(WLBuildToolNameSwiftLint) 2>/dev/null && echo "YES"),YES)
$(error "$(WLBuildToolNameSwiftLint)" does not exist. Solution: brew install $(WLBuildToolNameSwiftLint))
endif

WLBuildToolNameSwiftOSX = swift-osx
ifneq ($(shell hash $(WLBuildToolNameSwiftOSX) 2>/dev/null && echo "YES"),YES)
$(error "$(WLBuildToolNameSwiftOSX)" does not exist. Solution: Verify environment variables.)
endif

ifeq ($(WLIsUnderTesting),)
swiftlint: swiftlint_
headers: headers_
else
$(info Skipped.)
swiftlint:
headers:
endif

default: swiftlint headers

headers_:
	@"$(WLBuildPhaseCheckHeadersScriptPath)" "$(WLSourcesDirectoryPath)/Swift" "WaveLabs"
	@"$(WLBuildPhaseCheckHeadersScriptPath)" "$(WLSourcesDirectoryPath)/ObjC" "WaveLabs"
	@"$(WLBuildPhaseCheckHeadersScriptPath)" "$(WLSourcesDirectoryPath)/Tests" "WaveLabs"

swiftlint_:
	@"$(WLBuildPhaseSwiftLintScriptPath)" "$(WLSourcesDirectoryPath)/Swift" "$(WLSourcesDirectoryPath)/Common/swiftlint.yml"
