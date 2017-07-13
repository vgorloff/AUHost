#!/usr/bin/env ruby

gitRepoDirPath = File.expand_path("#{File.dirname(__FILE__)}/../../")

targetName = ENV['TARGET_NAME']
if targetName == "Attenuator"
   `pluginkit -v -a "#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex"`
end