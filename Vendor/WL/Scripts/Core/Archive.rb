class Archive

   def self.zip(fileOrDir, output = nil)
      if File.directory?(fileOrDir)
         targetDir = File.dirname(fileOrDir)
         fileName = File.basename(fileOrDir)
         archiveName = "#{fileName}.zip"
         outputFilePath = "#{targetDir}/#{archiveName}"
         if File.exist?(outputFilePath)
            puts "→ Deleting file \"#{outputFilePath}\"."
            File.delete(outputFilePath)
         end
         puts "→ Making archive \"#{outputFilePath}\"."
         `cd \"#{targetDir}\" && zip --symlinks -r \"#{archiveName}\" \"#{fileName}\"`
         if !output.nil?
            FileUtils.mv(outputFilePath, output)
         end
      else
         raise "Not implemented"
      end
   end

   def self.unzip(filePath, outputPath = nil)
      outputPath = outputPath.nil? ? File.dirname(filePath) : outputPath
      cmd = "unzip -q \"#{filePath}\" -d \"#{outputPath}\""
      puts cmd
      system cmd
   end

end
