MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile) then require MainFile else require_relative "Vendor/WL/Scripts/lib/Core.rb" end

class Automation

   GitRepoDirPath = ENV['PWD']
      
   def self.ci()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make ci"
      # system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make ci"
   end
   
   def self.build()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make build"
      # system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make build"
   end
   
   def self.clean()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make clean"
      # system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make clean"
   end
   
   def self.test()
      puts "! Nothing to do."
   end
   
   def self.release()
      
   end
   
   def self.verify()
      system "cd \"#{GitRepoDirPath}/SampleAUHost\" && make verify"
      # system "cd \"#{GitRepoDirPath}/SampleAUPlugin\" && make verify"
   end
   
   def self.deploy()
      puts "! Nothing to do."
   end

end