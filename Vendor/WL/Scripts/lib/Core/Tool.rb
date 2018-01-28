require 'fileutils'

class Tool
  
  ENV_KEY_CARTHAGE = 'CARTHAGE'
  ENV_KEY_TARGET_INTERFACE_BUILDER = 'TARGET_INTERFACE_BUILDER'
  ENV_KEY_XCODE_PRODUCT_BUILD_VERSION = 'XCODE_PRODUCT_BUILD_VERSION'
  ENV_KEY_CONFIGURATION = 'CONFIGURATION'
  ENV_KEY_CI_TRAVIS = 'TRAVIS'

  def self.toolsVersions
    puts "Tools versions:"
    puts "→ Ruby: " + `which ruby && ruby -v`.strip.gsub("\n", ' | ')
    puts "→ Fastlane: " + `fastlane --version`.strip.gsub("-", '').gsub("\n\n", '').gsub("\n", ' | ')
    puts "→ Brew: " + `which brew && brew -v`.strip.gsub("\n", ' | ')
    puts "→ Carthage: " + `which carthage && carthage version`.strip.gsub("\n", ' | ')
    puts "→ Cocoapods: " + `which pod && pod --version`.strip.gsub("\n", ' | ')
    puts "→ SwiftLint: " + `which swiftlint && swiftlint version`.strip.gsub("\n", ' | ')
  end
  
  def canRunActions(action = nil)
    actionName = action != nil ? " \"#{action}\"" : ""
    if isRelease()
      puts "* Execution#{actionName} skipped in release build (on CI server will be executed in pre-build step)."
      return false
    end
    if isCarthage()
      puts "* Execution#{actionName} skipped when building Carthage."
      return false
    end
    if isInterfaceBuilder()
      puts "* Execution#{actionName} skipped when building Interface Builder target."
      return false
    end
    return true
  end

  def self.isCIServer
    return ENV['XCS'].to_s.length > 0 || isTravisCI || ENV['JENKINS_HOME'].to_s.length > 0
  end
  
  def self.isTravisCI()
    return ENV[ENV_KEY_CI_TRAVIS].to_s.length > 0
  end
  
  def self.announceEnvVars()
    result = ENV.to_h.map { |k,v|
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
  
  def self.canRunSwiftGen()
    t = Tool.new()
    return !Tool.isCIServer && t.isCommandExists("swiftgen")
  end
  
  def self.xcodeBuildVersion()
    pattern = /Build version (.+)$/
    m = pattern.match(`xcodebuild -version`.strip())
    unless m
      raise "Unable to get \"Xcode build tools version\" from `xcodebuild -version`"
      exit
    end
    return m[1]
  end
  def self.xcodePath()
    result = `xcode-select --print-path`.strip
    return result
  end
  def self.isXcodeBeta()
    result = xcodePath.include?("Xcode-beta.app")
    return result
  end
 
  def isCommandExists(toolName)
    status = system("hash #{toolName} 2>/dev/null")
    if status == false
      puts "warning: Executable \"#{toolName}\" does not exist. Solution: `brew install #{toolName}`"
    end
    return status
  end
   
  def isCarthage()
    envVariable = ENV[ENV_KEY_CARTHAGE].to_s
    return envVariable.downcase == "yes"
  end
   
  def isInterfaceBuilder()
    envVariable = ENV[ENV_KEY_TARGET_INTERFACE_BUILDER]
    return envVariable != nil
  end
   
  def isRelease()
    envVariable = ENV[ENV_KEY_CONFIGURATION].to_s
    return envVariable.downcase.include?("release")
  end
  
  def isXcodeBuild()
    envVariable = ENV[ENV_KEY_XCODE_PRODUCT_BUILD_VERSION]
    return envVariable != nil
  end
end
