#!/usr/bin/env ruby -w

require 'fileutils'
require "#{File.realpath(File.dirname(__FILE__))}/Extensions/File.rb"

class FileHeaderChecker
   
   module ElementID
      FileName = 1
      ProjectName = 2
      Author = 3
      Copyright = 4
   end
   
   FileHeaderElement = Struct.new(:type, :value, :lineNumber)
   
   def initialize(projectNames)
      @projectNames = projectNames
      @fileExtensions = [".h", ".m", ".mm", ".swift", ".metal", ".xcconfig"]
   end
   def analyse(fileOrDirectoryPath)
      filePathsToAnalyze = []
      if File.directory?(fileOrDirectoryPath)
         filePathsToAnalyze = Dir["#{fileOrDirectoryPath}/**/*"].select { |f| File.file?(f) }
      elsif File.file?(fileOrDirectoryPath)
         filePathsToAnalyze = [fileOrDirectoryPath]
      else
         raise ArgumentError.new("Expected path to file or directory. Observed \"#{fileOrDirectoryPath}\"")
      end
      self.analyseFiles(filePathsToAnalyze)
   end
   def analyseFiles(filePathsToAnalyze)
     invalidResults = []
     filePathsToAnalyze = filePathsToAnalyze.select { |f| @fileExtensions.include?(File.extname(f)) }
     filePathsToAnalyze.each { |f|
        begin
           headerLines = File.head(f, 16)
           headerElements = parseFileHeader(headerLines)
           results = analyseHeader(f, headerElements)
           invalidResults += generateError(f, results)
        rescue Exception => e
           invalidResults.push("#{f}:1: warning: #{e.message}")
        end
     }
     return invalidResults
   end
   def performAnalysis(fileOrDirectoryPath)
      filePathsToAnalyze = []
      if File.directory?(fileOrDirectoryPath)
         filePathsToAnalyze = Dir["#{fileOrDirectoryPath}/**/*"].select { |f| File.file?(f) }
      elsif File.file?(fileOrDirectoryPath)
         filePathsToAnalyze = [fileOrDirectoryPath]
      else
         raise ArgumentError.new("Expected path to file or directory. Observed \"#{fileOrDirectoryPath}\"")
      end
      self.analyseFiles(filePathsToAnalyze)
   end
   def generateError(filePath, headerElements)
      results = []
      headerElements.each { |el|
         prefix = "#{File.realpath(filePath)}:#{el.lineNumber}: warning:"
         if el.type == ElementID::FileName
            results.push("#{prefix} Unexpected file name. Expected \"#{File.basename(filePath)}\".")
         elsif el.type == ElementID::ProjectName
            results.push("#{prefix} Unexpected project name. Expected \"#{@projectNames.join(", ")}\".")
         elsif el.type == ElementID::Author
            results.push("#{prefix} Invalid value for \"Author\".")
         elsif el.type == ElementID::Copyright
            results.push("#{prefix} Invalid value for \"Copyright\".")
         end
      }
      return results
   end
   def analyseHeader(filePath, headerElements)
      invalidElements = []
      headerElements.each { |el|
         value = el.value
         if el.type == ElementID::FileName && value != File.basename(filePath)
            invalidElements.push(el)
         elsif el.type == ElementID::ProjectName && !@projectNames.include?(value)
            invalidElements.push(el)
         elsif el.type == ElementID::Author && value.empty?
            invalidElements.push(el)
         elsif el.type == ElementID::Copyright && value.empty?
            invalidElements.push(el)
         end
      }
      return invalidElements
   end
   def parseFileHeader(fileHeaderLines)
      line = fileHeaderLines[0].strip
      if line == "//"
         return parseFileHeaderV1(fileHeaderLines)
      elsif line.start_with? "///"
         return parseFileHeaderV2(fileHeaderLines)
      elsif line.start_with? "/**"
         return parseFileHeaderV3(fileHeaderLines)
      elsif line.start_with? "//!"
         return [] # 3rd party source file.
      else
         raise "Unknown structure for header for file \"#{fileHeaderLines}\""
      end
   end
   def parseFileHeaderV1(fileHeaderLines)
      headerLines = []
      fileHeaderLines.each { |line|
         if line.start_with?('//')
            headerLines.push(line)
         else
            break
         end
      }
      headerLines = headerLines.map { |line| line.sub(/^\/\//, '') }.map { |line| line.strip }
      if headerLines.count != 7
         raise "Unexpected header structure. Should be 7 lines starting from \"//\"."
      else
         return [
            FileHeaderElement.new(ElementID::FileName, headerLines[1], 2),
            FileHeaderElement.new(ElementID::ProjectName, headerLines[2], 3),
            FileHeaderElement.new(ElementID::Author, headerLines[4], 5),
            FileHeaderElement.new(ElementID::Copyright, headerLines[5], 6)
         ]
      end
   end
   def parseFileHeaderV2(fileHeaderLines)
      headerLines = []
      fileHeaderLines.each { |line|
         if line.start_with?('///')
            headerLines.push(line)
         else
            break
         end
      }
      headerLines = headerLines.map { |line| line.sub(/^\/\/\//, '') }.map { |line| line.strip }
      if headerLines.count != 4
         raise "Unexpected header structure. Should be 4 lines starting from \"/// \"."
      else
         return [
            FileHeaderElement.new(ElementID::FileName, headerLines[0].sub(/^\w+:\s+/, ''), 1),
            FileHeaderElement.new(ElementID::ProjectName, headerLines[1].sub(/^\w+:\s+/, ''), 2),
            FileHeaderElement.new(ElementID::Author, headerLines[2].sub(/^\w+:\s+/, ''), 3),
            FileHeaderElement.new(ElementID::Copyright, headerLines[3].sub(/^\w+:\s+/, ''), 4)
         ]
      end
   end
   def parseFileHeaderV3(fileHeaderLines)
      raise "Not implemented"
   end
end
