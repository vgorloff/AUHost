#!/usr/bin/env ruby

projectDirPath = File.expand_path("#{File.dirname(__FILE__)}/../")
gitRepoDirPath = File.expand_path("#{projectDirPath}/../")

require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/FileHeaderChecker.rb"
require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"
require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"

exit(0) if !Tool.verifyEnvironment("Check Headers")

changedFiles = GitStatus.new(gitRepoDirPath).changedFiles
puts FileHeaderChecker.new(["Attenuator"]).analyseFiles(changedFiles.select { |f| f.start_with?("#{projectDirPath}/Attenuator/Sources")} )
puts FileHeaderChecker.new(["Attenuator"]).analyseFiles(changedFiles.select { |f| f.start_with?("#{projectDirPath}/AttenuatorAU/Sources")} )
puts FileHeaderChecker.new(["Attenuator"]).analyseFiles(changedFiles.select { |f| f.start_with?("#{projectDirPath}/AttenuatorKit/Sources")} )
puts FileHeaderChecker.new(["AUHost"]).analyseFiles(changedFiles.select { |f| f.start_with?("#{projectDirPath}/Shared")} )
puts FileHeaderChecker.new(["WaveLabs"]).analyseFiles(changedFiles.select { |f| f.start_with?("#{projectDirPath}/Vendor/WL")} )
