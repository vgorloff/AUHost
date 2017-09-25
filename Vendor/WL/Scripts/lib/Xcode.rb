#!/usr/bin/env ruby -w

require 'fileutils'

class Xcode
   def self.eraseDerivedData
      derivedDataPaths = Dir["#{ENV['HOME']}/Library/Caches/AppCode*/DerivedData"].select { |f| File.directory? f }.map{ |f| File.absolute_path f }
      derivedDataPaths.push("#{ENV['HOME']}/Library/Developer/Xcode/DerivedData")
      derivedDataPaths.each { |dirPath|
         eraseDerivedDataDirectory(dirPath)
      }
      eraseClandCache()
      cleanDeploymentLocations()
   end
   
   def self.cleanDeploymentLocations
      deploymentLocations = Dir["/tmp/*.dst"]
      deploymentLocations.each { |d|
         puts "→ Deleting deployment location dirictory: #{d}"
         FileUtils.remove_dir(d)
      }
   end
   
   def self.eraseDerivedDataDirectory(dirPath)
      dirsToRemove = Dir["#{dirPath}/*/Build"].select { |f| File.directory? f }
      dirsToRemove.each { |d|
         puts "→ Deleting dirictory: #{d}"
         FileUtils.remove_dir(d)
      }
   
      allDirs = Dir["#{dirPath}/*"].select { |f| File.directory? f }
      allDirs.each { |d|
         isEmpty = Dir["#{d}/*"].empty?
         if isEmpty
            puts "→ Deleting empty dirictory: #{d}"
            FileUtils.remove_dir(d)
         end
      }
   
      moduleCacheDirs = Dir["#{dirPath}/ModuleCache"].select { |f| File.directory? f }
      moduleCacheDirs.each { |d|
         puts "→ Deleting module cache dirictory: #{d}"
         FileUtils.remove_dir(d)
      }
   end

   def self.eraseClandCache
      userCacheDir = `getconf DARWIN_USER_CACHE_DIR`.strip + "org.llvm.clang.#{ENV['USER']}/ModuleCache"
      if File.directory?(userCacheDir)
         puts "→ Deleting user module cache dirictory: #{userCacheDir}"
         FileUtils.remove_dir(userCacheDir)
      end
   end
end