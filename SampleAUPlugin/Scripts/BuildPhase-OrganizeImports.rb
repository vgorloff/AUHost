#!/usr/bin/env ruby

require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/ImportsOrganizer.rb"
require "#{ENV['PWD']}/Vendor/WL/Conf/Scripts/lib/Tool.rb"

exit(0) if !Tool.verifyEnvironment("Organize Imports")

ImportsOrganizer.new().process("#{ENV['PWD']}/Attenuator/Sources")
ImportsOrganizer.new().process("#{ENV['PWD']}/AttenuatorAU/Sources")
ImportsOrganizer.new().process("#{ENV['PWD']}/AttenuatorKit/Sources")
ImportsOrganizer.new().process("#{ENV['PWD']}/Shared")
ImportsOrganizer.new().process("#{ENV['PWD']}/Vendor/WL")