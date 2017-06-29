#!/usr/bin/env ruby

projectDirPath = File.expand_path("#{File.dirname(__FILE__)}/../")
gitRepoDirPath = File.expand_path("#{projectDirPath}/../")

require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"
require "#{projectDirPath}/Vendor/WL/Conf/Scripts/lib/Tool.rb"

exit(0) if !Tool.canRunSwiftLint()

GitStatus.new(gitRepoDirPath).changedFiles("swift").each { |f|
   puts `swiftlint autocorrect --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
   puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
}
