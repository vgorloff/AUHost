#!/usr/bin/env ruby -w

require 'fileutils'

class GitStatus
   def initialize(gitRepoPath)
      @gitRepoPath = gitRepoPath
   end
   def changedFiles(extension = nil)
      files1 = `cd #{@gitRepoPath} && git ls-files -m -o --exclude-standard --exclude-from=.gitignore`.split("\n")
      files2 = `cd #{@gitRepoPath} && git diff --name-only --cached`.split("\n")
      files = (files1 + files2).uniq
      files = files.map{ |f| "#{@gitRepoPath}/#{f.strip()}" }.sort
      files = files.select { |f| File.exists?(f) }.map{ |f| File.realpath(f) }
      unless extension.nil?
         files = files.select { |f| File.extname(f) == ".#{extension}" }
      end
      return files
   end
end

# gs = GitStatus.new("/Users/vova/Cloud/Repositories/GitHub/AUHost")
# puts gs.changedFiles("swift")
