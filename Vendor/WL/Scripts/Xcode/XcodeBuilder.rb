require 'fileutils'
require_relative '../Extensions/AnsiTextStyles.rb'
require_relative '../Core/PlistTool.rb'
require_relative '../Core/Environment.rb'

module BuildConfiguration
   DEBUG = 'Debug'.freeze
   RELEASE = 'Release'.freeze
end

module BuildSetting
   CODESIGNING_FOLDER_PATH = 'CODESIGNING_FOLDER_PATH'.freeze
end

class XcodeBuilder

   def initialize(projectFilePath, buildRoot = ENV['PWD'])
      require 'securerandom'
      require 'tmpdir'
      @isVerbodeMode = Environment.isDebug
      @buildRoot = buildRoot
      @projectFilePath = projectFilePath
      @buildDir = "#{buildRoot}/DerivedData"
      @derivedDataPath = " -derivedDataPath \"#{@buildDir}\" "

      @buildExecutable = 'xcrun xcodebuild'
      @commonArgsXCPretty = ""
      unless @isVerbodeMode
         @buildExecutable = "set -o pipefail && #{@buildExecutable}"
         @commonArgsXCPretty = "| xcpretty --color --simple"
      end
      @exportPlistFilePath = File.join(Dir.tmpdir, "ruby-automation.#{SecureRandom.uuid}.xml")
   end

   def test(schema, configuration = nil)
      c = configuration.nil? ? "" : "-configuration #{configuration}"
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" #{c} #{@derivedDataPath} test #{@commonArgsXCPretty}"
      system(cmd)
      if $?.exitstatus != 0
         raise "Test failed with status: #{$?.exitstatus}"
      end
   end

   def archive(schema, configuration = nil, skipExport = false)
      c = configuration.nil? ? "" : "-configuration #{configuration}"
      archivePath = "#{@buildDir}/#{schema}.xcarchive"
      exportPath = "#{@buildDir}/#{schema}.export"
      puts "→ Building archive to \"#{archivePath}\"".green
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -archivePath \"#{archivePath}\" #{c} #{@derivedDataPath} archive #{@commonArgsXCPretty}"
      system(cmd)
      if skipExport
         return
      end
      prepareExportOptionsPlist()
      puts "→ Exporting archive to \"#{exportPath}\"".green
      cmd = "xcodebuild -exportArchive -archivePath \"#{archivePath}\" -exportPath \"#{exportPath}\" -exportOptionsPlist \"#{@exportPlistFilePath}\" "
      system(cmd)
      if $?.exitstatus != 0
         raise "Archive failed with status: #{$?.exitstatus}"
      end
   end

   def self.validateBinary(path)
      puts "→ Checking binary \"#{path}\"".green
      puts "Codesign".bold
      printf `xcrun codesign --verify --deep --strict --verbose=1 \"#{path}\"`
      puts "Check signature ".bold
      printf `xcrun check-signature \"#{path}\"`
      puts "Spctl".bold
      printf `xcrun spctl -a -t exec -vv \"#{path}\"`
   end

   def getBuildSetting(name, configuration = BuildConfiguration::DEBUG)
      cmd = "xcodebuild -project \"#{@projectFilePath}\" -showBuildSettings -configuration #{configuration} | grep #{name}"
      value = `#{cmd}`
      value = value.split("=").last.strip
      return value
   end

   private

   def prepareExportOptionsPlist()
      p = PlistTool.new(@exportPlistFilePath)
      p.addString("method", "development")
      contents = File.readlines(@exportPlistFilePath).join()
      puts contents
   end

end
