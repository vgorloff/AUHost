MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile) then require MainFile else require_relative "Vendor/WL/Scripts/lib/Core.rb" end

class Automation

   GitRepoDirPath = ENV['PWD']
   VersionFilePath = GitRepoDirPath + "/Configuration/Version.xcconfig"
   XCodeProjectFilePathAUHost = GitRepoDirPath + "/AUHost.xcodeproj"
   XCodeProjectFilePathPlugIn = GitRepoDirPath + "/Attenuator.xcodeproj"
      
   def self.ci()
      XcodeBuilder.new(XCodeProjectFilePathAUHost).ci("AUHost")
      XcodeBuilder.new(XCodeProjectFilePathPlugIn).ci("Attenuator")
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
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make verify"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make verify"
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