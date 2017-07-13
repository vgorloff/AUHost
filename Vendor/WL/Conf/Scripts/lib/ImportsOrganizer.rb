#!/usr/bin/env ruby -w

require 'fileutils'
require "#{File.realpath(File.dirname(__FILE__))}/Extensions/File.rb"

class ImportsOrganizer
   
   def initialize()
      @fileExtensions = [".h", ".m", ".mm", ".swift"]
   end
   def processFiles(filePathsToAnalyze)
      filePathsToAnalyze = filePathsToAnalyze.select { |f|  @fileExtensions.include?(File.extname(f)) }
      filePathsToAnalyze.each { |f|
         fileContentsLines = File.readlines(f)
         isCoreected, updatedFileContentsLines = correctImportsIfNeeded(fileContentsLines)
         if isCoreected
            puts(" → Corrected file \"#{f}\".")
            File.open(f, "w+") do |file|
              updatedFileContentsLines.each { |element| file.puts(element) }
            end
         end
      }
   end
   def process(fileOrDirectoryPath)
      filePathsToAnalyze = []
      if File.directory?(fileOrDirectoryPath)
         filePathsToAnalyze = Dir["#{fileOrDirectoryPath}/**/*"].select { |f| File.file?(f) }
      elsif File.file?(fileOrDirectoryPath)
         filePathsToAnalyze = [fileOrDirectoryPath]
      else
         raise ArgumentError.new("Expected path to file or directory. Observed \"#{fileOrDirectoryPath}\"")
      end
      self.processFiles(filePathsToAnalyze)
   end
   def correctImportsIfNeeded(fileContentsLines)
      indexOfFirstImport = -1
      indexOfLastImport = -1
      for index in 0..fileContentsLines.count
         line = fileContentsLines[index].to_s
         if line.start_with?("import") || line.start_with?("@import") || line.start_with?("#import")
            if indexOfFirstImport < 0
               indexOfFirstImport = index
            end
         else
            if indexOfFirstImport >= 0 && indexOfLastImport < 0
               indexOfLastImport = index - 1
               break
            end
         end
      end
   
      if !(indexOfLastImport > indexOfFirstImport) # Nothing to optimize
         return false, fileContentsLines
      end
      
      length = indexOfLastImport - (indexOfFirstImport - 1)
      importsSection = fileContentsLines.slice(indexOfFirstImport, length)
      sortedImports = importsSection.uniq.sort
      
      if !(importsSection != sortedImports) # Nothing to optimize
         return false, fileContentsLines
      end
      
      updatedContentsLines = fileContentsLines.slice(0, indexOfFirstImport) + sortedImports +
                             fileContentsLines.slice(indexOfLastImport + 1, (fileContentsLines.count - (indexOfLastImport + 1)))

      return true, updatedContentsLines
   end
   
end

# ImportsOrganizer.new().process("/Users/vova/Cloud/Repositories/GitHub/AUHost/SampleAUHost/Vendor/WL/Core/AlternativeValue.swift")
