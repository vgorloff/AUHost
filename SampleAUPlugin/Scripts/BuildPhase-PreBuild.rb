#!/usr/bin/env ruby

gitRepoDirPath = File.expand_path("#{File.dirname(__FILE__)}/../../")

require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/FileHeaderChecker.rb"
require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"
require "#{gitRepoDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"

changedFiles = GitStatus.new(gitRepoDirPath).changedFiles

targetName = ENV['TARGET_NAME']
if targetName == "AttenuatorKit"
   if Tool.verifyEnvironment("Check Headers")
      puts "→ Checking headers..."
      puts FileHeaderChecker.new(["Attenuator", "AUHost", "WaveLabs"]).analyseFiles(changedFiles)
   end
   if Tool.canRunSwiftLint()
      puts "→ Linting..."
      changedFiles.select { |f| File.extname(f) == ".swift" }.each { |f|
         puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
      }
   end
else targetName == "Attenuator"
   `pluginkit -v -r "#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex"`
end