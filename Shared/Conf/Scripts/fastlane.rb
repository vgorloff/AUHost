
class BuildSettings
  @@NoCodesign = {
    "CODE_SIGN_IDENTITY" => "",
    "CODE_SIGNING_REQUIRED" => "NO",
    "CODE_SIGN_ENTITLEMENTS" => "",
    "AWLSkipBuildScripts" => "true"
  }
  @@Codesign = {
    "CODE_SIGNING_REQUIRED" => "YES",
    "AWLSkipBuildScripts" => "true"
  }
  def self.NoCodesign
    @@NoCodesign
  end
  def self.Codesign
    @@Codesign
  end
end

def XcodeClean(*schemes)
  schemes.each { |schema|
    xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-configuration Debug clean")
    xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-configuration Release clean")
  }
  awl_buildDir = "#{ENV['PWD']}/build"
  sh "if [ -d \"#{awl_buildDir}\" ]; then rm -rfv \"#{awl_buildDir}\"; fi"
end

def XcodeCleanProject(schema, project)
   sh "set -o pipefail && xcrun xcodebuild -project \"#{ENV['PWD']}/#{project}\" -scheme \"#{schema}\" -configuration Debug clean | xcpretty --color --simple"
   sh "set -o pipefail && xcrun xcodebuild -project \"#{ENV['PWD']}/#{project}\" -scheme \"#{schema}\" -configuration Release clean | xcpretty --color --simple"
  awl_buildDir = "#{ENV['PWD']}/build"
  sh "if [ -d \"#{awl_buildDir}\" ]; then rm -rfv \"#{awl_buildDir}\"; fi"
end

def XcodeTest(*schemes)
  schemes.each { |schema|
    scan(scheme: schema, output_directory: "fastlane/test_output/#{schema}")
  }
end

def XcodeMacOSTest(*schemes)
  schemes.each { |schema|
    scan(scheme: schema, output_directory: "fastlane/test_output/#{schema}", destination: "platform=macOS")
  }
end

def XcodeBuild(*schemes)
  schemes.each { |schema|
    xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign)
  }
end

def XcodeBuildProject(schema, project, configuration = nil)
   configurationValue = configuration == nil ? "" : "-configuration #{configuration}"
   sh "set -o pipefail && xcrun xcodebuild -project \"#{ENV['PWD']}/#{project}\" -scheme \"#{schema}\" #{configurationValue} build | xcpretty --color --simple"
end

def XcodeBuildProjectCI(schema, project)
   sh "set -o pipefail && xcrun xcodebuild -project \"#{ENV['PWD']}/#{project}\" -scheme \"#{schema}\" -configuration Release CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY='' AWLSkipBuildScripts=true build | xcpretty --color --simple"
end

def XcodeBuildProjectGitHub(schema, project)
   sh "set -o pipefail && xcrun xcodebuild -project \"#{ENV['PWD']}/#{project}\" -scheme \"#{schema}\" -configuration Release AWLSkipBuildScripts=true build | xcpretty --color --simple"
end

def XcodeBuildCodesign(*schemes)
  schemes.each { |schema|
    xcodebuild(scheme: schema, build_settings: BuildSettings.Codesign, xcargs: "-configuration Release")
  }
end

def XcodeBuildRelease(*schemes)
  schemes.each { |schema|
    xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-configuration Release")
  }
end

def GetPropertyCodesignFolderPath(project)
  awl_AppPath = (sh "xcodebuild -project #{project} -showBuildSettings -configuration Release | grep CODESIGNING_FOLDER_PATH | grep -oEi \"\/.*\"").strip
  return awl_AppPath
end

def ValidateApp(*paths)
   paths.each { |path|
      sh "xcrun codesign --verify --deep --strict --verbose=1 \"#{path}\""
      sh "xcrun check-signature \"#{path}\""
      sh "xcrun spctl -a -t exec -vv \"#{path}\""
   }
end

def Bump(*relativePaths)
  awl_versionFromTag = last_git_tag
  values = git_branch.split("/")
  values.each do |value|
      if ( value =~ /\d+\.\d+\.\d+/ )
        awl_versionFromTag = value
      end
  end
  relativePaths.each { |relativePath|
    awl_buildNumber = increment_build_number(xcodeproj: relativePath)
    increment_version_number(version_number: awl_versionFromTag, xcodeproj: relativePath)
    git_commit(path: "./", message: "Version Bump #{awl_versionFromTag}x#{awl_buildNumber}")
  }
end

def SelfUpdate
   sh "gem cleanup && gem update --user-install fastlane scan --no-ri --no-rdoc --no-document && fastlane --version"
end

def ValidateSources
   scriptFileName = "#{ENV['PWD']}/Scripts/BuildPhase-Validate.sh"
   if File.file?(scriptFileName)
      sh "\"#{scriptFileName}\""
   end
end

# class XcodeBuild
#   def self.Clean(*schemes)
#     puts self.inspect
#     # XcodeBuildClean(schemes)
#   end
#   def initialize
#     # puts "foo"
#   end
# end

