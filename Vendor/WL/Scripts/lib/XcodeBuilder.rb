require "#{File.realpath(File.dirname(__FILE__))}/Extensions/AnsiTextStyles.rb"

class XcodeBuilder
   def initialize(projectFilePath, buildRoot = ENV['PWD'])
      @buildRoot = buildRoot
      @projectFilePath = projectFilePath
      @buildDir = "#{buildRoot}/DerivedData"
      @commonArgsXCPretty = "| xcpretty --color --simple"
      @buildExecutable = "set -o pipefail && xcrun xcodebuild"
      @derivedDataPath = " -derivedDataPath \"#{@buildDir}\" "
   end
   def build(schema, configuration = nil)
      c = configuration == nil ? "" : "-configuration #{configuration}"
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" #{c} #{@derivedDataPath} build #{@commonArgsXCPretty}"
      system(cmd)
   end
   def test(schema, configuration = nil)
      c = configuration == nil ? "" : "-configuration #{configuration}"
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" #{c} #{@derivedDataPath} test #{@commonArgsXCPretty}"
      system(cmd)
   end
   def archive(schema, configuration = nil, skipExport = false)
      c = configuration == nil ? "" : "-configuration #{configuration}"
      archivePath = "#{@buildDir}/#{schema}.xcarchive"
      exportPath = "#{@buildDir}/#{schema}.export"
      exportOptionsPath = "#{File.realpath(File.dirname(__FILE__))}/Resources/xcode.exportOptions.macOS.plist"
      puts "→ Building archive to \"#{archivePath}\"".green
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -archivePath \"#{archivePath}\" #{c} #{@derivedDataPath} archive #{@commonArgsXCPretty}"
      system(cmd)
      if skipExport
         return
      end
      puts "→ Exporting archive to \"#{exportPath}\"".green
      cmd = "xcodebuild -exportArchive -archivePath \"#{archivePath}\" -exportPath \"#{exportPath}\" -exportOptionsPlist \"#{exportOptionsPath}\" "
      system(cmd)
   end
   def clean(schema)
      configurations = ["Debug", "Release"]
      configurations.each { |c|
         cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -configuration #{c} #{@derivedDataPath} clean #{@commonArgsXCPretty}"
         system(cmd)
      }
      if File.directory?(@buildDir)
         puts("→ Deleting directory #{@buildDir}")
         FileUtils.rm_r(@buildDir)
      end
   end
   def ci(schema)
      codesignSettings = "CODE_SIGNING_REQUIRED=NO CODE_SIGN_IDENTITY=''"
      cmd = "#{@buildExecutable} -project \"#{@projectFilePath}\" -scheme \"#{schema}\" -configuration Release #{codesignSettings}  #{@derivedDataPath} build #{@commonArgsXCPretty}"
      system(cmd)
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
