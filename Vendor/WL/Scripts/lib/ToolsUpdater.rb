class ToolsUpdater
   def initialize()
      @commonArgs = "--no-ri --no-rdoc --no-document --quiet --user-install"
   end
   def self.toolsVersions
      puts("Tools versions:")
      puts("→ Ruby: " + `which ruby && ruby -v`.strip.gsub("\n", ' | '))
      puts("→ Fastlane: " + `which fastlane && fastlane --version`.strip.gsub("\n", ' | '))
      puts("→ Brew: " + `which brew && brew -v`.strip.gsub("\n", ' | '))
      puts("→ Carthage: " + `which carthage && carthage version`.strip.gsub("\n", ' | '))
      puts("→ Cocoapods: " + `which pod && pod --version`.strip.gsub("\n", ' | '))
      puts("→ SwiftLint: " + `which swiftlint && swiftlint version`.strip.gsub("\n", ' | '))
   end
   def updateGems(gems)
      system("gem cleanup")
      system("gem update #{@commonArgs} #{gems}")
      system("gem cleanup")
   end
end
