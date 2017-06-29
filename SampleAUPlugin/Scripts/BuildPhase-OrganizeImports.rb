#!/usr/bin/env ruby

projectDirPath = File.expand_path("#{File.dirname(__FILE__)}/../")
gitRepoDirPath = File.expand_path("#{projectDirPath}/../")

require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/ImportsOrganizer.rb"
require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"
require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"

exit(0) if !Tool.verifyEnvironment("Organize Imports")

changedFiles = GitStatus.new(gitRepoDirPath).changedFiles
ImportsOrganizer.new().processFiles(changedFiles.select{ |f| f.start_with?("#{projectDirPath}/Attenuator/Sources")} )
ImportsOrganizer.new().processFiles(changedFiles.select{ |f| f.start_with?("#{projectDirPath}/AttenuatorAU/Sources")} )
ImportsOrganizer.new().processFiles(changedFiles.select{ |f| f.start_with?("#{projectDirPath}/AttenuatorKit/Sources")} )
ImportsOrganizer.new().processFiles(changedFiles.select{ |f| f.start_with?("#{projectDirPath}/Shared")} )
ImportsOrganizer.new().processFiles(changedFiles.select{ |f| f.start_with?("#{projectDirPath}/Vendor/WL")} )