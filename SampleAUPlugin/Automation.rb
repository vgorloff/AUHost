MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile) then require MainFile else require_relative "Vendor/WL/Scripts/lib/Core.rb" end

class Automation

   GitRepoDirPath = ENV['PWD']
   XCodeProjectFilePath = GitRepoDirPath + "/Attenuator.xcodeproj"
   XCodeProjectSchema = "Attenuator"
      
   def self.ci()
      XcodeBuilder.new(XCodeProjectFilePath).ci(XCodeProjectSchema)
   end
   
   def self.build()
      XcodeBuilder.new(XCodeProjectFilePath).build(XCodeProjectSchema)
   end
   
   def self.clean()
      XcodeBuilder.new(XCodeProjectFilePath).clean(XCodeProjectSchema)
   end

   def self.post()
      targetName = ENV['TARGET_NAME']
      if targetName == "Attenuator"
         `pluginkit -v -a "#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex"`
      end
   end
   
   def self.release()
      XcodeBuilder.new(XCodeProjectFilePath).archive(XCodeProjectSchema)
   end
   
   def self.verify()
      if Tool.isCIServer
         return
      end
      t = Tool.new()
      l = Linter.new(GitRepoDirPath)
      h = FileHeaderChecker.new(["Attenuator", "WaveLabs"])
      if t.isXcodeBuild
         if t.canRunActions("Verification")
            changedFiles = GitStatus.new(GitRepoDirPath).changedFiles()
            puts "→ Checking headers..."
            puts h.analyseFiles(changedFiles)
            if l.canRunSwiftLint()
               puts "→ Linting..."
               l.lintFiles(changedFiles)
            end
         end
      else
         puts h.analyseDir(GitRepoDirPath)
         if l.canRunSwiftFormat()
            puts "→ Correcting sources (SwiftFormat)..."
            l.correctWithSwiftFormat()
         end
         if l.canRunSwiftLint()
            puts "→ Correcting sources (SwiftLint)..."
            l.correctWithSwiftLint()
         end
      end
   end

end