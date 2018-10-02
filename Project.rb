MainFile = "#{ENV['AWL_LIB_SRC']}/Scripts/Automation.rb"
if File.exist?(MainFile)
  require MainFile
else
  Dir[File.dirname(__FILE__) + "/Vendor/WL/Scripts/**/*.rb"].each { |f| require f }
end

class Project < AbstractProject
  
  def initialize(rootDirPath)
    super(rootDirPath)
    @versionFilePath = @rootDirPath + "/Configuration/Version.xcconfig"
    @projectFilePath = @rootDirPath + "/Attenuator.xcodeproj"
    @tmpDirPath = @rootDirPath + "/DerivedData"
    @keyChainPath = @tmpDirPath + "/VST3NetSend.keychain"
    @p12FilePath = @rootDirPath + '/Codesign/DeveloperIDApplication.p12'
  end

  def ci()
    if !Environment.isCI
       release()
       return
    end
    puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    puts "→ Preparing environment..."
    FileUtils.mkdir_p @tmpDirPath
    puts Environment.announceEnvVars
    puts "→ Setting up keychain..."
    kc = KeyChain.create(@keyChainPath)
    puts KeyChain.list
    defaultKeyChain = KeyChain.default
    puts "→ Default keychain: #{defaultKeyChain}"
    kc.setSettings()
    kc.info()
    kc.import(@p12FilePath, ENV['AWL_P12_PASSWORD'], ["/usr/bin/codesign"])
    kc.setKeyCodesignPartitionList()
    kc.dump()
    KeyChain.setDefault(kc.nameOrPath)
    puts "→ Default keychain now: #{KeyChain.default}"
    begin
       puts "→ Making build..."
       XcodeBuilder.new(@projectFilePath).ci("AUHost")
       XcodeBuilder.new(@projectFilePath).ci("Attenuator")
       puts "→ Making cleanup..."
       KeyChain.setDefault(defaultKeyChain)
       KeyChain.delete(kc.nameOrPath)
    rescue
       KeyChain.setDefault(defaultKeyChain)
       KeyChain.delete(kc.nameOrPath)
       puts "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
       raise
    end
  end
  
  def build()
     XcodeBuilder.new(@projectFilePath).build("AUHost")
     XcodeBuilder.new(@projectFilePath).build("Attenuator")
  end
  
  def clean()
     XcodeBuilder.new(@projectFilePath).clean("AUHost")
     XcodeBuilder.new(@projectFilePath).clean("Attenuator")
  end
  
  def release()
     XcodeBuilder.new(@projectFilePath).archive("AUHost")
     XcodeBuilder.new(@projectFilePath).archive("Attenuator")
     apps = Dir["#{GitRepoDirPath}/**/*.export/*.app"].select { |f| File.directory?(f) }
     apps.each { |app| Archive.zip(app) }
     apps.each { |app| XcodeBuilder.validateBinary(app) }
  end

  def deploy()
     require 'yaml'
     assets = Dir["#{ENV['PWD']}/**/*.export/*.app.zip"]
     releaseInfo = YAML.load_file("#{GitRepoDirPath}/Configuration/Release.yml")
     releaseName = releaseInfo['name']
     releaseDescriptions = releaseInfo['description'].map { |l| "* #{l}"}
     releaseDescription = releaseDescriptions.join("\n")
     version = Version.new(@versionFilePath).projectVersion
     puts "! Will make GitHub release → #{version}: \"#{releaseName}\""
     puts releaseDescriptions.map { |l| "  #{l}" }
     assets.each { |f| puts "  #{f}" }
     gh = GitHubRelease.new("vgorloff", "AUHost")
     Readline.readline("OK? > ")
     gh.release(version, releaseName, releaseDescription)
     assets.each { |f| gh.uploadAsset(f) }
  end
  
  def generate()
    project = XcodeProject.new(projectPath: File.join(@rootDirPath, "Attenuator.xcodeproj"), vendorSubpath: 'WL')
    auHost = project.addApp(name: "AUHost", sources: ["Shared", "SampleAUHost"], platform: :osx, deploymentTarget: "10.11", buildSettings: {
      "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.AUHost", "DEPLOYMENT_LOCATION" => "YES"
    })
    addSharedSources(project, auHost)
    
    attenuator = project.addApp(name: "Attenuator", sources: ["Shared", "SampleAUPlugin/Attenuator", "SampleAUPlugin/AttenuatorKit"], platform: :osx, deploymentTarget: "10.11", buildSettings: {
      "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator", "DEPLOYMENT_LOCATION" => "YES"
    })
    addSharedSources(project, attenuator)
    
    auExtension = project.addAppExtension(name: "AttenuatorAU", sources: ["SampleAUPlugin/AttenuatorAU", "SampleAUPlugin/AttenuatorKit"], platform: :osx, deploymentTarget: "10.11", buildSettings: {
      "PRODUCT_BUNDLE_IDENTIFIER" => "ua.com.wavelabs.Attenuator.AttenuatorAU", "ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES" => "YES"
    })
    addSharedSources(project, auExtension)
    
    project.addDependencies(to: attenuator, dependencies: [auExtension])
    script = "ruby -r \"$SRCROOT/Project.rb\" -e \"Project.new('$SRCROOT').register()\""
    project.addScript(to: attenuator, script: script, name: "Register Extension", isPostBuild: true)

    project.save()
  end
  
  def register()
    cmd = "pluginkit -v -a \"#{ENV['CODESIGNING_FOLDER_PATH']}/Contents/PlugIns/AttenuatorAU.appex\""
    unless Environment.isCI
      puts cmd
      system cmd
    end
  end
  
  def addSharedSources(project, target)
    project.useFilters(target: target, filters: [
      "Core/Concurrency/*", "Core/Extensions/*", "Core/Converters/*Numeric*",
      "Core/Sources/AlternativeValue*", "Core/Sources/*Aliases*",
      "Foundation/os/log/*", "Foundation/Sources/*Info*", "Foundation/Testability/*", "Foundation/ObjectiveC/*", "Foundation/Notification/*",
      "Foundation/Sources/Functions*", "Foundation/Extensions/CG*", "Foundation/Extensions/*Insets*", "Foundation/Extensions/Color*",
      "Foundation/Sources/Result*", "Foundation/Sources/Math.swift", "Foundation/Extensions/String*",
      "Types/Sources/MinMax*", "Types/Sources/Random*", "Types/Sources/Operators*",
      "Media/Extensions/*", "Media/Sources/Waveform*", "Media/Sources/Media*", "Media/Sources/*Utility*",
      "Media/Sources/*Type*", "Media/Sources/*Buffer*",
      "AppKit/Media/Media*", "AppKit/Media/VU*", "AppKit/Media/*DisplayLink*", "AppKit/Media/*Error*",
      "AppKit/Extensions/*Toolbar*",
      "Media/DSP/*Value*"
    ])
  end

end