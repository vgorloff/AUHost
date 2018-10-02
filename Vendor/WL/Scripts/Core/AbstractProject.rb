require_relative '../Extensions/AnsiTextStyles.rb'
String.include(AnsiTextStyles)

class AbstractProject

   def initialize(rootDirPath)
      @rootDirPath = rootDirPath
   end

   def clean()
      deleteXcodeFiles()
   end

   def generate()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def ci()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def deploy()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def release()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def build()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def makeWorkspace(name:)
      require 'xcodeproj'
      projectPath = File.join(@rootDirPath, "#{name}.xcworkspace")
      project = Xcodeproj::Workspace.new(nil)
      xcodeProjects = Dir[@rootDirPath + "/*.xcodeproj"]
      xcodeProjects.each { |comp|
         baseName = File.basename(comp)
         fileRef = Xcodeproj::Workspace::FileReference.new(baseName)
         project << fileRef
      }
      project.save_as(projectPath)
   end

   def verify(directoryPathComponent = nil)
      swiftFormatConfig = File.exist?("#{@rootDirPath}/.swiftformat") ? nil : ENV['AWL_LIB_SRC'] + '/.swiftformat'
      swiftLintConfig = File.exist?("#{@rootDirPath}/.swiftlint.yml") ? nil : ENV['AWL_LIB_SRC'] + '/.swiftlint.yml'
      linter = Linter.new(@rootDirPath, swiftLintConfig, swiftFormatConfig)
      if directoryPathComponent.nil?
         issues = linter.verify(shouldPrintProgress: false) + verifyHeaders(shouldPrintProgress: false)
         unless issues.empty?
            puts issues.join("\n")
            exit 1
         end
      else
         dirPath = "#{@rootDirPath}/#{directoryPathComponent}"
         changedFiles = GitStatus.new(@rootDirPath).changedFilesInDir(dirPath, 'swift')
         component = directoryPathComponent.split("/").reject { |comp| ["iOS", "macOS", "tvOS"].include?(comp) }.first
         knownNames = ['WL', component].uniq
         results = []
         results += FileHeaderChecker.new(knownNames).analyseFiles(changedFiles) if Environment.canRunAction('Verify Headers')
         results += linter.verifyFiles(changedFiles)
         puts results.join("\n") unless results.empty?
      end
   end

   def autocorrect()
      isVerbose = !Environment.isXcodeBuild
      swiftFormatConfig = File.exist?("#{@rootDirPath}/.swiftformat") ? nil : ENV['AWL_LIB_SRC'] + '/.swiftformat'
      swiftLintConfig = File.exist?("#{@rootDirPath}/.swiftlint.yml") ? nil : ENV['AWL_LIB_SRC'] + '/.swiftlint.yml'
      linter = Linter.new(@rootDirPath, swiftLintConfig, swiftFormatConfig)
      linter.autocorrect(shouldPrintProgress: isVerbose)
      autocorrectStrings(shouldPrintProgress: isVerbose)
      changedFiles = GitStatus.new(@rootDirPath).changedFiles().map { |file| "- #{file}" }
      if !changedFiles.empty? && isVerbose
         puts '✖ Autocorrection produced changes listed below. Please commit and try again.'.red
         puts changedFiles.join("\n")
         puts ''
      end
      linterWarnings = linter.verify(shouldPrintProgress: isVerbose)
      linterWarnings = linterWarnings.map { |line| "- #{line}" } if isVerbose
      unless linterWarnings.empty?
         puts '✖ Verification detected warnings listed below. Please correct files and/or commit changes.'.red if isVerbose
         puts linterWarnings.join("\n")
         puts '' if isVerbose
      end
      headerWarnings = verifyHeaders(shouldPrintProgress: isVerbose)
      headerWarnings = headerWarnings.map { |line| "- #{line}" } if isVerbose
      unless headerWarnings.empty?
         puts '✖ Verification detected warnings listed below. Please correct files and/or commit changes.'.red if isVerbose
         puts headerWarnings.join("\n")
         puts '' if isVerbose
      end
      if isVerbose && (!changedFiles.empty? || !linterWarnings.empty? || !headerWarnings.empty?)
         puts '✖ Verification failed :O'.red
         exit 1
      elsif !linterWarnings.empty? || !headerWarnings.empty?
         exit 1
      end
   end

   def assets()
      cmd = 'swiftgen'
      if Environment.isCommandExists(cmd)
         templatesDir = "#{ENV['AWL_LIB_SRC']}/Shared/Assets/XcodeGen"
         baseDir = "#{@rootDirPath}/mcAssets"
         assetsTemplate = "--templatePath \"#{templatesDir}/Images.stencil\"" # Default template: "--template swift4"
         stringsTemplate = "--templatePath \"#{templatesDir}/Strings.stencil\"" # Default template: "--template structured-swift4"
         coloursTemplate = "--templatePath \"#{templatesDir}/Colors.stencil\"" # Default template: "--template swift4"

         puts '→ Generating Assets and Strings ...'
         mediaSourceFile = "#{baseDir}/Media.xcassets"
         if File.exist? mediaSourceFile
            execute "#{cmd} xcassets #{assetsTemplate} --output \"#{baseDir}/MediaAsset.swift\" \"#{mediaSourceFile}\""
         end
         stringsSourceFile = "#{baseDir}/en.lproj/Localizable.strings"
         if File.exist? stringsSourceFile
            execute "#{cmd} strings #{stringsTemplate} --output \"#{baseDir}/LocalizableStrings.swift\" \"#{stringsSourceFile}\""
         end
         coloursSourceFile = "#{baseDir}/Colors.xcassets"
         if File.exist? coloursSourceFile
            execute "#{cmd} xcassets #{coloursTemplate} --output \"#{baseDir}/ColorAsset.swift\" \"#{coloursSourceFile}\""
         end
         puts '← Generation Completed!'
      end
   end

   def deleteXcodeFiles()
      files = Dir[@rootDirPath + "/*.xcodeproj"] + Dir[@rootDirPath + "/*.xcworkspace"]
      files.each { |file|
         puts " - Deleting #{file}"
         FileUtils.rm_r(file)
      }
   end

   def autocorrectStrings(shouldPrintProgress: true)
      strings = Dir["#{@rootDirPath}/**/*.lproj/InfoPlist.strings"]
      strings += Dir["#{@rootDirPath}/**/*.lproj/Localizable.strings"]
      puts '→ Correcting Localizable Strings...'.green if shouldPrintProgress
      ls = LocalizedString.new
      strings.each { |file| ls.sort(file, file) }
   end

   def verifyHeaders(shouldPrintProgress: true)
      result = []
      if Environment.canRunAction('Verify Headers')
         puts '→ Verifying sources (Headers)...'.green if shouldPrintProgress
         knownNames = ['WL']
         dirsToAnalyze = Dir["#{@rootDirPath}/*"].select { |file| File.directory?(file) }
         dirsToAnalyze.each { |dir|
            component = File.basename(dir)
            result += FileHeaderChecker.new(knownNames + [component]).analyseDir(dir)
         }
      end
      return result
   end

   def execute(command)
      puts(command)
      system(command)
   end
end
