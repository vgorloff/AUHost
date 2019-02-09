require 'fileutils'

class Environment

   def self.toolsVersions
      puts "Tools versions:"
      puts "→ Ruby: " + `which ruby && ruby -v`.strip.gsub("\n", ' | ')
      puts "→ Fastlane: " + `fastlane --version`.strip.delete("-").gsub("\n\n", "\n").gsub("\n", ' | ')
      puts "→ Brew: " + `which brew && brew -v`.strip.gsub("\n", ' | ')
      puts "→ Carthage: " + `which carthage && carthage version`.strip.gsub("\n", ' | ')
      # puts "→ Cocoapods: " + `which pod && pod --version`.strip.gsub("\n", ' | ')
      puts "→ SwiftLint: " + `which swiftlint && swiftlint version`.strip.gsub("\n", ' | ')
      puts "→ SwiftFormat: " + `which swiftformat && swiftformat --version`.strip.gsub("\n", ' | ')
      puts "→ SwiftGen: " + `which swiftgen && swiftgen --version`.strip.gsub("\n", ' | ')
      puts "→ XcodeGen: " + `which xcodegen`.strip.gsub("\n", ' | ')
      # Seems Xcodegen break itself due missed `--version` argument.
      # puts "→ XcodeGen: " + `which xcodegen && xcodegen --version`.strip.gsub("\n", ' | ')
      puts "→ Xcode: " + xcodePath() + " | " + `which xcodebuild && xcodebuild -version`.strip.gsub("\n", ' | ')
   end

   def self.canRunAction(action)
      if isRelease()
         puts "* Execution #{action} skipped in release build (on CI server will be executed in pre-build step)."
         return false
      end
      if isCarthage()
         puts "* Execution #{action} skipped when building Carthage."
         return false
      end
      if isInterfaceBuilder()
         puts "* Execution #{action} skipped when building Interface Builder target."
         return false
      end
      return true
   end

   def self.canRunActions()
      if isRelease()
         puts "* Execution skipped in release build (on CI server will be executed in pre-build step)."
         return false
      end
      if isCarthage()
         puts "* Execution skipped when building Carthage."
         return false
      end
      if isInterfaceBuilder()
         puts "* Execution skipped when building Interface Builder target."
         return false
      end
      return true
   end

   def self.isCI()
      return isXcodeCI || isTravisCI || isJenkinsCI || isGenericCI
   end

   def self.isDebug()
      return !ENV['DEBUG'].to_s.empty?
   end

   def self.isTravisCI()
      return !ENV['TRAVIS'].to_s.empty?
   end

   def self.isXcodeCI()
      return !ENV['XCS'].to_s.empty?
   end

   def self.isJenkinsCI()
      return !ENV['JENKINS_HOME'].to_s.empty?
   end

   def self.isGenericCI()
      return !ENV['CI'].to_s.empty?
   end

   def self.announceEnvVars()
      result = ENV.to_h.map { |k, v|
         value = v
         if k.downcase().include?('password')
            value = 'Password is Hidden'
         end
         if k.downcase().include?('access_key')
            value = 'Access Key is Hidden'
         end
         "#{k}=#{value}"
      }
      return result.sort
   end

   def self.xcodeBuildVersion()
      pattern = /Build version (.+)$/
      matches = pattern.match(`xcodebuild -version`.strip())
      unless matches
         raise "Unable to get \"Xcode build tools version\" from `xcodebuild -version`"
      end
      return matches[1]
   end

   def self.xcodePath()
      result = `xcode-select --print-path`.strip
      return result
   end

   def self.isXcodeBeta()
      result = xcodePath.include?("Xcode-beta.app")
      return result
   end

   def self.isCommandExists(toolName)
      status = system("hash #{toolName} 2>/dev/null")
      if status == false
         puts "warning: Executable \"#{toolName}\" does not exist. Solution: `brew install #{toolName}` or `gem install --user-install #{toolName}`"
      end
      return status
   end

   def self.isCarthage()
      value = ENV['CARTHAGE'].to_s
      return value.casecmp("yes").zero?
   end

   def self.isAlfred()
      return !ENV['alfred_version'].nil?
   end

   def self.isInterfaceBuilder()
      value = ENV['TARGET_INTERFACE_BUILDER']
      return !value.nil?
   end

   def self.isRelease()
      value = ENV['CONFIGURATION'].to_s
      return value.downcase.include?("release")
   end

   def self.isXcodeBuild()
      value = ENV['XCODE_PRODUCT_BUILD_VERSION']
      return !value.nil?
   end

   def self.destinationRev
      return ENV['BITRISEIO_GIT_BRANCH_DEST'] # i.e. `develop`
   end

   def self.sourceRev
      return ENV['BITRISE_GIT_BRANCH'] # i.e. `feature/something`
   end

end
