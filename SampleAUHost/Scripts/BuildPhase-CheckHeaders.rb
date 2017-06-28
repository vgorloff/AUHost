#!/usr/bin/env ruby

require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/FileHeaderChecker.rb"
require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/Tool.rb"

exit(0) if !Tool.verifyEnvironment("Check Headers")

puts FileHeaderChecker.new(["AUHost"]).performAnalysis("#{ENV['PWD']}/Sources")
puts FileHeaderChecker.new(["AUHost"]).performAnalysis("#{ENV['PWD']}/Shared")
puts FileHeaderChecker.new(["WaveLabs"]).performAnalysis("#{ENV['PWD']}/Vendor/WL")
