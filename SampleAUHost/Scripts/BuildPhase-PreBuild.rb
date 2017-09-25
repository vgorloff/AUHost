#!/usr/bin/env ruby

gitRepoDirPath = File.expand_path("#{File.dirname(__FILE__)}/../../")

libraryFilePath = "#{ENV['AWL_LIB_SRC']}/Scripts/WL.rb"
if File.exists?(libraryFilePath)
   require libraryFilePath
else
   require "#{gitRepoDirPath}/Vendor/WL/Scripts/WL.rb"
end

changedFiles = GitStatus.new(gitRepoDirPath).changedFiles

targetName = ENV['TARGET_NAME']
if targetName == "AUHost"
   if Tool.verifyEnvironment("Check Headers")
      puts "→ Checking headers..."
      puts FileHeaderChecker.new(["AUHost", "WaveLabs"]).analyseFiles(changedFiles)
   end
   if Tool.canRunSwiftLint()
      puts "→ Linting..."
      changedFiles.select { |f| File.extname(f) == ".swift" }.each { |f|
         puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
      }
   end
end