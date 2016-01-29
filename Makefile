.PHONY: default all clean build

AWLBuildRootDirPath:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
AWLBuildDirPath:=$(AWLBuildRootDirPath)/DerivedData
AWLBuildToolName = xctool
AWLBuildToolAvailable = $(shell hash $(AWLBuildToolName) 2>/dev/null && echo "YES" )
AWLArgsSDKOSX = -sdk macosx10.11

AWLArgsBuildReporter = -reporter plain
AWLArgsCommon = -derivedDataPath "$(AWLBuildDirPath)" $(AWLArgsSDKOSX) DEPLOYMENT_LOCATION=NO
AWLArgsNoCodesign = CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGN_ENTITLEMENTS=""
AWLArgsDevIDCodesign = CODE_SIGN_IDENTITY="Developer ID Application" CODE_SIGNING_REQUIRED=YES
AWLArgsRelease = -configuration Release
AWLArgsDebug = -configuration Debug
AWLBuildConfigAUPlugIn = -project AUSamplePlugIn/Attenuator.xcodeproj -scheme AttenuatorAU
AWLArgsEnvVariables = AWLBuildSkipAuxiliaryScripts=YES

ifneq ($(AWLBuildToolAvailable),YES)
$(error "$(AWLBuildToolName)" does not exist. Solution: brew install $(AWLBuildToolName))
endif

default:
	@echo "Available targets:"
	@echo "    all:\t Invoke targets: clean build"
	@echo "    clean:\t Cleans all build targets and configurations"
	@echo "    build:\t Builds all build targets and configurations"
	
all: \
	clean \
	build

clean:
	rm -rf "$(AWLBuildDirPath)"
	
build: build_release_auplugin_nocodesign
	
build_release_auplugin_nocodesign:
	$(AWLArgsEnvVariables) xctool $(AWLArgsBuildReporter) $(AWLArgsCommon) $(AWLArgsNoCodesign) $(AWLArgsRelease) $(AWLBuildConfigAUPlugIn) build

clean_release_auplugin_nocodesign:
	$(AWLArgsEnvVariables) xctool $(AWLArgsBuildReporter) $(AWLArgsCommon) $(AWLArgsNoCodesign) $(AWLArgsRelease) $(AWLBuildConfigAUPlugIn) clean

build_release_auplugin_codesign: 
	$(AWLArgsEnvVariables) xctool $(AWLArgsBuildReporter) $(AWLArgsCommon) $(AWLArgsDevIDCodesign) $(AWLArgsRelease) $(AWLBuildConfigAUPlugIn) build
	find "$(AWLBuildDirPath)" -type d -iname *.app | xargs -I{} sh -c 'xcrun spctl -a -t exec -vv "{}"; xcrun codesign --verify "{}"'
	for AWLAppPath in `find "$(AWLBuildDirPath)" -type d -iname *.app`; do \
		xcrun spctl -a -t exec -vv "$$AWLAppPath"; \
		xcrun codesign --verify "$$AWLAppPath"; \
		AWLArchiveDirPath=`dirname "$$AWLAppPath"`; AWLArchiveName=`basename "$$AWLAppPath"`; cd "$$AWLArchiveDirPath"; rm "$$AWLArchiveName.zip"; zip -r "$$AWLArchiveName.zip" "$$AWLArchiveName"; \
	done
	