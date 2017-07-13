#!/usr/bin/env ruby -w

require 'fileutils'

# puts ENV.inspect

class Tool
   def self.verifyBrewToolExists(toolName)
      status = system("hash #{toolName} 2>/dev/null")
      if status == false
         puts "warning: Executable \"#{toolName}\" does not exist. Solution: `brew install #{toolName}`"
      end
      return status
   end
   def self.verifyEnvironment(commandName = nil)
      command = commandName != nil ? " \"#{commandName}\"" : ""
      if ENV['CONFIGURATION'] == "Release"
         puts "Execution#{command} skipped in \"Release\" configuration (on CI server will be executed from Fastlane)."
         return false
      end
      if ENV['CARTHAGE'] == "YES"
         puts "Execution#{command} skipped when building Carthage."
         return false
      end
      if ENV['TARGET_INTERFACE_BUILDER'] != nil
         puts "Execution#{command} skipped when building Interface Builder target."
         return false
      end
      return true
   end
   def self.canRunSwiftLint()
      return Tool.verifyEnvironment("swiftlint") && Tool.verifyBrewToolExists("swiftlint")
   end
end

# puts Tool.verifyBrewToolExists("swiftlint")
