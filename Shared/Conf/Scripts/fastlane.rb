
class BuildSettings
  @@NoCodesign = {
    "CODE_SIGN_IDENTITY" => "",
    "CODE_SIGNING_REQUIRED" => "NO",
    "CODE_SIGN_ENTITLEMENTS" => "",
    "AWLSkipBuildScripts" => "true"
  }
  @@Codesign = {
    "CODE_SIGN_IDENTITY" => "Developer ID Application",
    "CODE_SIGNING_REQUIRED" => "YES",
    "PROVISIONING_PROFILE_SPECIFIER" => "E27KE6VTF6/",
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
  xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-project #{project} -configuration Debug clean")
  xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-project #{project} -configuration Release clean")
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

def XcodeBuildProject(schema, project)
  xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-project #{project}")
end

def XcodeBuildProjectRelease(schema, project)
  xcodebuild(scheme: schema, build_settings: BuildSettings.NoCodesign, xcargs: "-project #{project} -configuration Release")
end

def XcodeBuildProjectCodesign(schema, project)
  xcodebuild(scheme: schema, build_settings: BuildSettings.Codesign, xcargs: "-project #{project} -configuration Release")
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

def ValidateApp(path)
  sh "xcrun spctl -a -t exec -vv \"#{path}\"; xcrun codesign --verify \"#{path}\""
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

