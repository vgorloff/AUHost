Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

# def GetPropertyCodesignFolderPath(project)
#   awl_AppPath = (sh "xcodebuild -project #{project} -showBuildSettings -configuration Release | grep CODESIGNING_FOLDER_PATH | grep -oEi \"\/.*\"").strip
#   return awl_AppPath
# end
#
# def Bump(*relativePaths)
#   awl_versionFromTag = last_git_tag
#   values = git_branch.split("/")
#   values.each do |value|
#       if ( value =~ /\d+\.\d+\.\d+/ )
#         awl_versionFromTag = value
#       end
#   end
#   relativePaths.each { |relativePath|
#     awl_buildNumber = increment_build_number(xcodeproj: relativePath)
#     increment_version_number(version_number: awl_versionFromTag, xcodeproj: relativePath)
#     git_commit(path: "./", message: "Version Bump #{awl_versionFromTag}x#{awl_buildNumber}")
#   }
# end

def srcUnsync(projectFilePath)
   srcDirPath = ENV['AWL_LIB_SRC']
   if Dir.exists?(srcDirPath)
      require 'xcodeproj'
      project = Xcodeproj::Project.open(projectFilePath)
      vendorGroup = project.groups.select { |g| g.path == "Vendor" || g.name == "Vendor" }.first
      if vendorGroup == nil
         puts "! Unable to find `Vendor` group."
         return
      end
      vendorGroup = vendorGroup.groups.select { |g| g.path == "WL" }.first
      vendorGroup.source_tree = "WL"
      vendorGroup.path = nil
      vendorGroup.name = "WL"
      project.save()
   end
end

def srcSync(projectFilePath, cleanup: true)
   srcDirPath = ENV['AWL_LIB_SRC']
   dstDirPath = "#{ENV['PWD']}/Vendor/WL"
   if Dir.exists?(srcDirPath)
      require 'xcodeproj'
      project = Xcodeproj::Project.open(projectFilePath)
      vendorGroup = project.groups.select { |g| g.path == "Vendor" || g.name == "Vendor" }
      vendorGroup = vendorGroup.first.groups.select { |g| g.name == "WL" }.first
      swiftFiles = vendorGroup.recursive_children.select { |c| c.respond_to?(:real_path) }.select { |f|
         f.real_path.to_s.end_with?(".swift") || f.real_path.to_s.end_with?(".metal")
      }
      swiftFiles = swiftFiles.map { |f| f.real_path.to_s.gsub("${WL}", ENV['AWL_LIB_SRC']) }
      scriptFiles = Dir["#{srcDirPath}/Scripts/**/*"].select { |f| !File.directory?(f) }
      files = swiftFiles + scriptFiles
      if Dir.exists?(dstDirPath) && cleanup
         puts "→ Deleting dir \"#{dstDirPath}\""
         FileUtils.rm_r(dstDirPath)
      end
      files.each { |f|
         dstFilePath = f.gsub(srcDirPath, dstDirPath)
         dstFileDirPath = File.dirname(dstFilePath)
         FileUtils.mkdir_p(dstFileDirPath)
         FileUtils.cp(f, dstFileDirPath, :verbose => true)
      }
      vendorGroup.source_tree = "<group>"
      vendorGroup.path = "WL"
      vendorGroup.name = nil
      project.save()
      puts "→ Done!"
   else
      puts "! Environment variable if not found `AWL_LIB_SRC`. Skipping."
   end
end
