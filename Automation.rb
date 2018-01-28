MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile) then require MainFile else require_relative "Vendor/WL/Scripts/lib/Core.rb" end

class Automation

   GitRepoDirPath = ENV['PWD']
   VersionFilePath = GitRepoDirPath + "/Configuration/Version.xcconfig"
      
   def self.ci()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make ci"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make ci"
   end
   
   def self.build()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make build"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make build"
   end
   
   def self.clean()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make clean"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make clean"
   end
   
   def self.test()
      puts "! Nothing to do."
   end
   
   def self.release()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make release"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make release"
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