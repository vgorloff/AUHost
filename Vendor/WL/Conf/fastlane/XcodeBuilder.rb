require "#{File.realpath(File.dirname(__FILE__))}/AnsiTextStyles.rb"

class XcodeBuilder
   def initialize(lane, projectFilePath, buildRoot = ENV['PWD'])
      @lane = lane
      @buildRoot = buildRoot
      @projectFilePath = projectFilePath
      @buildDir = "#{buildRoot}/DerivedData"
      @commonArgsXCPretty = "| xcpretty --color --simple"
      @buildExecutable = "set -o pipefail && xcrun xcodebuild"
      @derivedDataPath = " -derivedDataPath \"#{@buildDir}\" "
   end
   def build(schema, configuration = nil)
      c = configuration == nil ? "" : "-configuration #{configuration}"
      @lane.sh "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" #{c} #{@derivedDataPath} build #{@commonArgsXCPretty}"
   end
   def clean(schema)
      configurations = ["Debug", "Release"]
      configurations.each { |c|
         @lane.sh "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -configuration #{c} #{@derivedDataPath} clean #{@commonArgsXCPretty}"
      }
      if File.directory?(@buildDir)
         puts("→ Deleting directory #{@buildDir}")
         FileUtils.rm_r(@buildDir)
      end
   end
   def ci(schema)
      codesignSettings = "CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=''"
      @lane.sh "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -configuration Release #{codesignSettings}  #{@derivedDataPath} build #{@commonArgsXCPretty}"
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
end
