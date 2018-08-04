MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile)
  require MainFile
else
  Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |f| require f }
end

class Automation

   GitRepoDirPath = ENV['PWD']
   VersionFilePath = GitRepoDirPath + "/Configuration/Version.xcconfig"
   XCodeProjectFilePathAUHost = GitRepoDirPath + "/AUHost.xcodeproj"
   XCodeProjectFilePathPlugIn = GitRepoDirPath + "/Attenuator.xcodeproj"
   TmpDirPath = GitRepoDirPath + "/DerivedData"
   KeyChainPath = TmpDirPath + "/VST3NetSend.keychain"
   P12FilePath = GitRepoDirPath + '/Codesign/DeveloperIDApplication.p12'
      
   def self.ci()
     if !Tool.isCIServer
        release()
        return
     end
     puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
     puts "→ Preparing environment..."
     FileUtils.mkdir_p TmpDirPath
     puts Tool.announceEnvVars
     puts "→ Setting up keychain..."
     kc = KeyChain.create(KeyChainPath)
     puts KeyChain.list
     defaultKeyChain = KeyChain.default
     puts "→ Default keychain: #{defaultKeyChain}"
     kc.setSettings()
     kc.info()
     kc.import(P12FilePath, ENV['AWL_P12_PASSWORD'], ["/usr/bin/codesign"])
     kc.setKeyCodesignPartitionList()
     kc.dump()
     KeyChain.setDefault(kc.nameOrPath)
     puts "→ Default keychain now: #{KeyChain.default}"
     begin
        puts "→ Making build..."
        XcodeBuilder.new(XCodeProjectFilePathAUHost).ci("AUHost")
        XcodeBuilder.new(XCodeProjectFilePathPlugIn).ci("Attenuator")
        puts "→ Making cleanup..."
        KeyChain.setDefault(defaultKeyChain)
        KeyChain.delete(kc.nameOrPath)
     rescue
        KeyChain.setDefault(defaultKeyChain)
        KeyChain.delete(kc.nameOrPath)
        puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        raise
     end
   end
   
   def self.build()
      XcodeBuilder.new(XCodeProjectFilePathAUHost).build("AUHost")
      XcodeBuilder.new(XCodeProjectFilePathPlugIn).build("Attenuator")
   end
   
   def self.clean()
      XcodeBuilder.new(XCodeProjectFilePathAUHost).clean("AUHost")
      XcodeBuilder.new(XCodeProjectFilePathPlugIn).clean("Attenuator")
   end
   
   def self.release()
      XcodeBuilder.new(XCodeProjectFilePathAUHost).archive("AUHost")
      XcodeBuilder.new(XCodeProjectFilePathPlugIn).archive("Attenuator")
      apps = Dir["#{GitRepoDirPath}/**/*.export/*.app"].select { |f| File.directory?(f) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end
   
   def self.verify()
      verifyHost()
      verifyPlugIn()
   end
   
   def self.post()
     if Tool.isCIServer
        return
     end
      targetName = ENV['TARGET_NAME']
      if targetName == "Attenuator"
         `pluginkit -v -a "#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex"`
      end
   end

   def self.verifyPlugIn()
      if Tool.isCIServer
         return
      end
      projectPath = GitRepoDirPath + "/SampleAUPlugin"
      t = Tool.new()
      l = Linter.new(projectPath, GitRepoDirPath + "/.swiftlint.yml")
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
         puts h.analyseDir(projectPath)
         if l.canRunSwiftFormat()
            puts "→ Correcting sources (SwiftFormat)..."
            l.correctWithSwiftFormat(projectPath)
         end
         if l.canRunSwiftLint()
            puts "→ Correcting sources (SwiftLint)..."
            l.correctWithSwiftLint()
         end
      end
   end
   
   def self.verifyHost()
      if Tool.isCIServer
         return
      end
      projectPath = GitRepoDirPath + "/SampleAUHost"
      t = Tool.new()
      l = Linter.new(projectPath, GitRepoDirPath + "/.swiftlint.yml")
      h = FileHeaderChecker.new(["AUHost", "WaveLabs"])
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
         puts h.analyseDir(projectPath)
         if l.canRunSwiftFormat()
            puts "→ Correcting sources (SwiftFormat)..."
            l.correctWithSwiftFormat(projectPath)
         end
         if l.canRunSwiftLint()
            puts "→ Correcting sources (SwiftLint)..."
            l.correctWithSwiftLint()
         end
      end
   end
   
   def self.deploy()
      require 'yaml'
      assets = Dir["#{ENV['PWD']}/**/*.export/*.app.zip"]
      releaseInfo = YAML.load_file("#{GitRepoDirPath}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescriptions = releaseInfo['description'].map { |l| "* #{l}"}
      releaseDescription = releaseDescriptions.join("\n")
      version = Version.new(VersionFilePath).projectVersion
      puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
      puts releaseDescriptions.map { |l| "  #{l}" }
      assets.each { |f| puts "  #{f}" }
      gh = GitHubRelease.new("vgorloff", "AUHost")
      Readline.readline("OK? > ")
      gh.release(version, releaseName, releaseDescription)
      assets.each { |f| gh.uploadAsset(f) }
   end

end