class Archive

  def self.zip(fileOrDir)
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
      `cd \"#{targetDir}\" && zip -r \"#{archiveName}\" \"#{fileName}\"`
    else
      raise "Not implemented"
    end
  end
end
