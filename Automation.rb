MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile) then require MainFile else require_relative "Vendor/WL/Scripts/lib/Core.rb" end

class Automation

   GitRepoDirPath = ENV['PWD']
      
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
      # sh "cd \"#{ENV['PWD']}/SampleAUHost\" && fastlane archive"
      # sh "cd \"#{ENV['PWD']}/SampleAUPlugin\" && fastlane archive"
      # apps = Dir["#{ENV['PWD']}/**/*.export/*.app"].select { |f| File.directory?(f) }
      # apps.each { |app| zip(path: app, output_path: "#{app}.zip") }
      # apps.each { |app| XcodeBuilder.validateBinary(app) }
   end
   
   def self.verify()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make verify"
      system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make verify"
   end
   
   def self.deploy()
      # assets = Dir["#{ENV['PWD']}/**/*.export/*.app.zip"]
      # releaseName = File.read("#{ENV['PWD']}/fastlane/ReleaseName.txt").strip
      # releaseDescription = File.read("#{ENV['PWD']}/fastlane/ReleaseNotes.txt").strip
      # github_release = set_github_release(
      #   repository_name: "vgorloff/AUHost", api_token: ENV['AWL_GITHUB_TOKEN'], name: releaseName, tag_name: last_git_tag,
      #   description: releaseDescription, commitish: "master", upload_assets: assets
      # )
   end

end