#!/usr/bin/env ruby

require 'fileutils'
require 'xcodeproj'

class ProjectTool

   def initialize(projectFilePath)
      @projectFilePath = projectFilePath
      @sourcesDirPath = File.dirname(projectFilePath)
      @project = Xcodeproj::Project.open(projectFilePath)
      @iosTarget = @project.native_targets.select { |target| target.name == "WL-iOS" }.first
      @macOSTarget = @project.native_targets.select { |target| target.name == "WL-macOS" }.first
      # deps = @uiTestsTarget.dependencies.map { |t| t.target }
      # @targets = @project.native_targets.select { |target|
      #    !target.name.end_with?("Tests") && /^nebenan\w+$/.match(target.name) == nil && !deps.include?(target) && target.name != "Nebenan3P"
      # }
   end
   def autocorrect
      sources = Dir["#{@sourcesDirPath}/**/*.swift"].select { |f|
         !f.start_with?("#{@sourcesDirPath}/Scripts") && !f.start_with?("#{@sourcesDirPath}/Tests") && !f.start_with?("#{@sourcesDirPath}/Playgrounds")
      }
      iosSources = sources.select { |f| !f.include?("macOS") }
      macOSSources = sources.select { |f| !f.include?("iOS") }
      addMissedSources(target: @iosTarget, files: iosSources)
      addMissedSources(target: @macOSTarget, files: macOSSources)
      sortGroups
      puts "→ Saving project: #{@projectFilePath}"
      @project.save()
   end
   
   # === PRIVATE ===
   
   private def sortGroups
      groups = @project.groups.select { |g| g.path != nil }
      groups.each { |g|
         puts "Sorting group \"#{g.path}\""
         g.sort_recursively(:groups_position => :above)
      }
      # groups.each { |g| g.sort_recursively_by_type }
      virtualGroups = @project.groups.select { |g| g.name != nil }
      virtualGroups.each { |g|
         puts "Sorting group \"#{g.name}\""
         if g.name == "Sources"
            g.sort_recursively(:groups_position => :above)
         else
            g.sort_by_type
         end
      }
   end
   # def addMissedResources(target: nil, files: [])
   #    normalFiles = @targets.map { |t| t.resources_build_phase.files.to_a }.inject(:+)
   #    testFiles = @uiTestsTarget.resources_build_phase.files.to_a
   #    normalFilesPaths = normalFiles.map { |f| f.file_ref.real_path.to_s }
   #    testFilesPaths = testFiles.map { |f| f.file_ref.real_path.to_s }
   #    missedFiles = normalFilesPaths - testFilesPaths
   #    missedFileRefs = normalFiles.select { |f| missedFiles.include?(f.file_ref.real_path.to_s) }
   #    missedFileRefs.each { |f|
   #       puts "→ Adding file to UITests target: #{f.file_ref.real_path}"
   #       @uiTestsTarget.resources_build_phase.add_file_reference(f.file_ref, true)
   #    }
   #    return missedFileRefs.count
   # end
  private def addMissedSources(target:, files:)
      # See also:
      # - https://github.com/CocoaPods/cocoapods-acknowledgements/blob/master/lib/cocoapods_acknowledgements.rb#L8-L26
      # - https://gist.github.com/masuidrive/5020507
      # - https://github.com/CocoaPods/Xcodeproj/issues/266
      rootGroup = @project.groups.select { |g| g.name == "Sources" }.first
      existingFiles = target.source_build_phase.files.to_a.map { |f| f.file_ref.real_path.to_s }
      missedFiles = files - existingFiles
      missedFiles.each { |f|
         puts "→ Adding file to #{target.name} target: #{f}"
         relativeFilePathComponents = f.gsub(@sourcesDirPath, '').split("/").select { |el| !el.empty? }
         groupPathComponents = relativeFilePathComponents.first(relativeFilePathComponents.size - 1)
         groupPath = groupPathComponents.join("/")
         group = rootGroup.find_subpath(groupPath, false)
         unless group
            group = rootGroup.find_subpath(groupPath, true)
            group.path = groupPathComponents.last
         end
         fileRef = group.files.find { |file| file.real_path.to_s == f}
         unless fileRef
            fileRef = group.new_file(f)
            fileRef.path = relativeFilePathComponents.last
         end
         target.add_file_references([fileRef])
      }
      if missedFiles.count > 0
         puts "= Added #{missedFiles.count} missed files."
      end
   end
end
