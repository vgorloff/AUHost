#!/usr/bin/env ruby

require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"
gitRepoDirPath = File.realpath("#{ENV['PWD']}/../")
changedFiles = GitStatus.new(gitRepoDirPath).changedFiles("swift")
changedFiles.each { |f|
   text = File.read(f)
   puts `swiftlint autocorrect --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
   puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
}
