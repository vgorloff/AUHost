MAIN_FILE = "#{ENV['AWL_SCRIPTS']}/Automation.rb".freeze
if File.exist?(MAIN_FILE)
   require MAIN_FILE
else
   Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |file| require file }
end

class Project < AbstractProject

   def initialize(rootDirPath)
      super(rootDirPath)
      @projectFilePath = @rootDirPath + "/Attenuator.xcodeproj"
   end

   def clean()
      XcodeBuilder.new(@projectFilePath).clean("AUHost-macOS")
      XcodeBuilder.new(@projectFilePath).clean("Attenuator-macOS")
   end

   def build()
      XcodeBuilder.new(@projectFilePath).build("AUHost-macOS")
      XcodeBuilder.new(@projectFilePath).build("Attenuator-macOS")
   end

   def release()
      XcodeBuilder.new(@projectFilePath).ci("AUHost-macOS")
      XcodeBuilder.new(@projectFilePath).ci("Attenuator-macOS")
   end

   def archive()
      XcodeBuilder.new(@projectFilePath).archive("AUHost-macOS")
      XcodeBuilder.new(@projectFilePath).archive("Attenuator-macOS")
      apps = Dir["#{@rootDirPath}/**/*.export/*.app"].select { |file| File.directory?(file) }
      apps.each { |app| Archive.zip(app) }
      apps.each { |app| XcodeBuilder.validateBinary(app) }
   end

   def deploy()
      assets = Dir["#{ENV['PWD']}/**/*.export/*.app.zip"]
      gitHubRelease(assets: assets)
   end

   def generate()
      deleteXcodeFiles()
      gen = XCGen.new(File.join(@rootDirPath, "Attenuator.xcodeproj"))
      gen.setDeploymentTarget("10.12", "macOS")

      auHost = gen.addApplication("AUHost", "SampleAUHost", "macOS")
      gen.addFiles(auHost, "Shared")
      gen.addBuildSettings(auHost, {
         "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.AUHost", "DEPLOYMENT_LOCATION" => "YES"
      })
      addSharedSources(gen, auHost, true)

      attenuator = gen.addApplication("Attenuator", "SampleAUPlugin/Attenuator", "macOS")
      gen.addFiles(attenuator, "Shared")
      gen.addFiles(attenuator, "SampleAUPlugin/AttenuatorKit")
      gen.addBuildSettings(attenuator, {
         "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator", "DEPLOYMENT_LOCATION" => "YES"
      })
      addSharedSources(gen, attenuator, true)

      auExtension = gen.addExtension("AttenuatorAU", "SampleAUPlugin/AttenuatorAU", "macOS")
      gen.addFiles(auExtension, "SampleAUPlugin/AttenuatorKit")
      gen.addBuildSettings(auExtension, {
         "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator.AttenuatorAU", "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES",
         "SWIFT_INCLUDE_PATHS" => "Shared"
      })
      addSharedSources(gen, auExtension)

      gen.addDependencies(attenuator, [auExtension])
      script = "ruby -r \"$SRCROOT/Project.rb\" -e \"Project.new('$SRCROOT').register()\""
      gen.addScript(attenuator, "Register Extension", script, true)

      gen.save()
   end

   def register()
      cmd = "pluginkit -v -a \"#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex\""
      unless Environment.isCI
         puts cmd
         system cmd
      end
   end

   def regenerate()
      super()
      execute "open -a Xcode #{@projectFilePath}"
   end

   def addSharedSources(gen, target, isAppKit = false)
      gen.addComponentFiles(target, [
         "Log.swift", "UnfairLock.swift", "String.swift", "NonRecursiveLocking.swift", "BuildInfo.swift", "RuntimeInfo.swift", "FileManager.swift",
         "Bundle.swift", "Functions.swift",
         "Buffered.+Bus\.swift", "BufferDatasource.swift", "SmartDispatchSource.*\.swift", "CVError.swift", "MTLDevice.swift",
         "VULevelMeter.*", "AppKit/.+/.*DisplayLink.*\.swift", "GLKMatrix4.swift"
      ])

      if isAppKit
         gen.addComponentFiles(target, [
            "AppKit/.+/(NS|)WindowController\.swift", "AppKit/.+/(NS|)Window\.swift", "AppKit/.+/(NS|)ViewController\.swift", "AppKit/.+/(NS|)Menu.*\.swift",
            "AppKit/.+/(NS|)View\.swift", "AppKit/.+/(NS|)Button\.swift", "NSControl.swift",
            "AppKit/.+/(NS|)StackView\.swift",
            "FailureReporting.swift", "ObjCAssociation.swift", "DispatchUntil.swift", "SystemAppearance.swift", "LayoutConstraint.swift",
            "EdgeInsets.swift", "LayoutPriority.swift", "CoreTypeAliases.swift", "(NS|)Dictionary.swift",
            "MediaObjectPasteboardUtility.swift", "WaveformCacheUtility.swift", "AlternativeValue.swift", "FullContentWindow.*\.swift",
            "DispatchQueue.swift", "ActionsBar.swift", "MediaLibraryUtility.swift", "AudioComponentsUtility.swift", "MinMax.swift",
            "WaveformDrawingDataProvider.swift", "TitlebarAccessoryViewController.swift", "ConstraintsSet.swift", "NSLayoutConstraint.swift",
            "NotificationObserver.swift", "OperationQueue.swift", "Result.swift", "NumericTypesConversions.swift", "Math.swift",
            "CGRect.swift", "Color.swift", "RandomFactory.swift", "NSToolbar.swift"
         ])
      end
   end

end
