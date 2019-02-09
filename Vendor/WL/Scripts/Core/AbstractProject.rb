require_relative '../Extensions/AnsiTextStyles.rb'
require_relative 'KeyChain.rb'
require 'json'

class AbstractProject

   attr_reader :rootDirPath

   def initialize(rootDirPath)
      @rootDirPath = rootDirPath
      @versionFilePath = @rootDirPath + "/Configuration/Version.xcconfig"
      @tmpDirPath = @rootDirPath + "/Build"
      @keyChainPath = @tmpDirPath + "/App.keychain"
      @p12FilePath = @rootDirPath + '/Shared/Codesign/DeveloperIDApplication.p12'
      @defaultKeyChain = KeyChain.default
   end

   def clean()
      deleteXcodeFiles()
   end

   def generate()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def regenerate()
      script = "xcode = Application('Xcode'); xcode.quit();"
      execute "osascript -l JavaScript -e \"#{script}\""
      sleep(2.0)
      generate()
   end

   def ci()
      unless Environment.isCI
         archive()
         return
      end
      puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      puts "→ Preparing environment..."
      prepare()
      FileUtils.mkdir_p @tmpDirPath
      puts Environment.announceEnvVars
      nameOrPath = setupKeyChain()
      begin
         puts "→ Making build..."
         release()
         puts "→ Making cleanup..."
         cleanupKeyChain(nameOrPath)
      rescue StandardError
         cleanupKeyChain(nameOrPath)
         puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
         raise
      end
   end

   def prepare()
      # Base class does nothing.
   end

   def update()
      # Base class does nothing. Update and Checkout dependencies.
   end

   def deploy()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def archive()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def release()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def build()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def test()
      puts "Base class \"#{__FILE__}\" does nothing."
   end

   def spmGenerate()
      # exe = "cd \"#{@rootDirPath}\" && swift package -Xswiftc \"-target\" -Xswiftc \"x86_64-apple-macosx10.12\" generate-xcodeproj"
      exe = "cd \"#{@rootDirPath}\" && swift package generate-xcodeproj"
      execute exe
      files = Dir[@rootDirPath + "/**/project.pbxproj"]
      files.each { |file|
         contents = File.readlines(file).reject { |line| line.include?("DEPLOYMENT_TARGET =") }.join()
         File.write(file, contents)
      }
      return spmInfo()
   end

   def spmInfo()
      exe = "cd \"#{@rootDirPath}\" && swift package dump-package"
      json = JSON.parse(`#{exe}`)
      return json
   end

   def spmSetupTestTargets(project)
      json = spmInfo()
      envVars = ENV.select { |key, _| (key.start_with?('AWL_') && !key.include?('TOKEN')) || key == "PATH" }
      targetNames = json['targets'].select { |target| target['type'] == "test" }.map { |target| target['name'] }
      targetNames.each { |name|
         puts "- Updating target: #{name}"
         target = project.findTarget(name)
         envVars.each { |key, val|
            project.addEnvVariable(target, key, val)
         }
      }
   end

   def spmSetupDeployTarget(project, target)
      target = project.findTarget(target)
      script = 'ditto "$TARGET_BUILD_DIR/$WRAPPER_NAME" "$AWL_SYS_HOME/lib/$WRAPPER_NAME"'
      project.embedLinkedFrameworks(target)
      project.addScript(target, "Deploy", script, true)
   end

   def spmSetupTargets(project)
      json = spmInfo()
      fwBuildSettings = {
         # "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES",
         "OTHER_LDFLAGS" => "$(inherited) -framework Cocoa -framework AppKit",
         "LD_RUNPATH_SEARCH_PATHS" => "$(inherited) $(TOOLCHAIN_DIR)/usr/lib/swift/macosx @executable_path/../Frameworks @loader_path/../Frameworks @loader_path/Frameworks"
      }
      products = json['products'].select { |target| target['product_type'] == "library" }
      if products.empty?
         # Xcode 10.2 fix
         products = json['products'].select { |target| target['type'].keys.include?("library") }
      end
      if products.empty?
         raise "Unable to find products"
      end
      targetNames = products.map { |target| target['name'] }
      targetNames.each { |name|
         puts "- Setting up SPM target #{name}"
         target = project.findTarget(name)
         project.addBuildSettings(target, fwBuildSettings)
         project.makeScheme(target)
      }
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
      return projectPath
   end

   def verify(directoryPathComponent = nil)
      if Environment.isCI
         return # CI doing verification separately prior to other actions.
      end
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

   def setupKeyChain()
      puts "→ Setting up keychain..."
      kc = KeyChain.create(@keyChainPath)
      puts KeyChain.list
      puts "→ Default keychain: #{@defaultKeyChain}"
      kc.setSettings()
      kc.info()
      kc.import(@p12FilePath, ENV['AWL_P12_PASSWORD'], ["/usr/bin/codesign"])
      kc.setKeyCodesignPartitionList()
      kc.dump()
      KeyChain.setDefault(kc.nameOrPath)
      puts "→ Default keychain now: #{KeyChain.default}"
      return kc.nameOrPath
   end

   def cleanupKeyChain(nameOrPath)
      KeyChain.setDefault(@defaultKeyChain)
      KeyChain.delete(nameOrPath)
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

   def gitHubRelease(assets: nil)
      require 'yaml'
      assets = assets.nil? ? Dir["#{@tmpDirPath}/**/*.export/*.zip"] : assets
      releaseInfo = YAML.load_file("#{@rootDirPath}/Configuration/Release.yml")
      releaseName = releaseInfo['name']
      releaseDescriptions = releaseInfo['description'].map { |line| "* #{line}" }
      releaseDescription = releaseDescriptions.join("\n")
      version = Version.new(@versionFilePath).projectVersion
      puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
      puts(releaseDescriptions.map { |line| "  #{line}" })
      assets.each { |file| puts "  #{file}" }
      gh = GitHubRelease.new("vgorloff", "AUHost")
      Readline.readline("OK? > ")
      gh.release(version, releaseName, releaseDescription)
      assets.each { |file| gh.uploadAsset(file) }
   end

   def assets()
      cmd = 'swiftgen'
      if !Environment.isCommandExists(cmd)
         return
      end
      templatesDir = "#{ENV['AWL_LIB_SRC']}/Shared/Assets/XcodeGen"
      baseDir = Dir["#{@rootDirPath}/*Assets"].first
      if baseDir.nil?
         p "No folder with Assets is found."
         return
      end
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
      puts(command.green)
      system(command)
   end
end
