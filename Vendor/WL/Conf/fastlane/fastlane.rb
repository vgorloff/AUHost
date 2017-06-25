require "#{File.realpath(File.dirname(__FILE__))}/XcodeBuilder.rb"

def GetPropertyCodesignFolderPath(project)
  awl_AppPath = (sh "xcodebuild -project #{project} -showBuildSettings -configuration Release | grep CODESIGNING_FOLDER_PATH | grep -oEi \"\/.*\"").strip
  return awl_AppPath
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
