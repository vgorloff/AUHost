#!/usr/bin/env ruby

require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/GitStatus.rb"
require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/Tool.rb"

exit(0) if !Tool.canRunSwiftLint()

GitStatus.new(File.realpath("#{ENV['PWD']}/../")).changedFiles("swift").each { |f|
   puts `swiftlint autocorrect --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
   puts `swiftlint lint --quiet --config \"#{gitRepoDirPath}/.swiftlint.yml\" --path \"#{f}\"`
}
