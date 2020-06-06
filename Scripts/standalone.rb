#!/usr/bin/env ruby

require 'fileutils'

srcRoot = File.realpath(File.dirname(File.dirname(__FILE__)))
projectPath = "#{srcRoot}/Shared.xcodeproj/project.pbxproj"
vendorPath = "#{srcRoot}/Vendor/mc"
contents = File.read(projectPath)
matches = contents.scan(/\.\.\/\.\.\/\.\.\/\.\.\/Projects\/mc\/(\w+)\/Sources/)
if matches.count == 0
   puts "➔ Nothing to do!"
   exit 0
end
if Dir.exists?(vendorPath)
   FileUtils.rm_r(vendorPath)
end
FileUtils.mkdir_p vendorPath
matches.each { |m|
   moduleName = m[0]
   from = "#{ENV["AWL_LIB_SRC"]}/#{moduleName}/Sources"
   toDir = "#{vendorPath}/#{moduleName}"
   to = "#{toDir}/Sources"
   FileUtils.mkdir_p(toDir)
   puts "➔ Copying '#{from}' to '#{to}'"
   FileUtils.cp_r from, to
}
contents = contents.gsub(/\.\.\/\.\.\/\.\.\/\.\.\/Projects\/mc\//, './mc/')
File.write(projectPath, contents)
