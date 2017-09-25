class Git
   def initialize(repoDirPath)
      @repo = repoDirPath
      @commonArgs = "--git-dir=#{@repo}/.git --work-tree=#{@repo}/"
      @git = "git #{@commonArgs}"
   end
   
   def pullAllBranches()
      fetch()
      default = defaultBranch()
      remote = remoteBranches()
      local = localBranches()
      puts "* Devault branch: #{default}"
      puts "* Local branches: #{local}"
      puts "* Remote branches: #{remote}"
      
      checkout(default)
      toDelete = local.reject{ |b| remote.include? b }
      toDelete.each { |branch|
         puts("! Deleting branch #{branch}...")
         sh = "#{@git} branch -D #{branch}"
         system(sh)
      }

      toUpdate = local.reject{ |b| b == default }
      if !toUpdate.empty?
         puts("→ Updating local branches: #{toUpdate}")
         toUpdate.each { |b| checkoutAndPool(branch: b) }
      end
      checkoutAndPool(branch: default)
   end
   
   # def pullAllBranches()
   #    cmd = "#{@git} branch -r | sed 's/^.//' | grep #{initialBranch}".strip
   #    isInitialBranchExists = `#{cmd}`.length > 0
   # end

   def pushAllBranches()
      sh = "#{@git} push --all origin"
      system(sh)
   end
   
   # === PRIVATE ===
   
   private def localBranches
      mergedBranches = `#{@git} branch --merged | sed 's/^. //'`.strip.split("\n").uniq
      localBranches = `#{@git} branch -vv | grep origin | sed 's/^. //' | awk '{print $1}'`.strip.split("\n").uniq
      return (localBranches + mergedBranches).uniq
   end
   
   private def remoteBranches
      remoteBranches = `#{@git} branch -r | sed 's/^.*->//' | sed 's/ *origin\\///'`.strip.split("\n").uniq
      return remoteBranches
   end
   
   private def initialBranch
      initialBranch = `#{@git} symbolic-ref --short -q HEAD`.strip
      return initialBranch
   end

   private def defaultBranch
      defaultBranch = `#{@git} branch -q --no-color --list 'develop*' | sed 's/^*//'`.strip
      defaultBranch = defaultBranch.empty? ? "master" : defaultBranch
      return defaultBranch
   end
   
   private def checkoutAndPool(branch:)
      puts("→ Checkout and pull: #{branch}")
      execute("#{@git} checkout -q #{branch}")
      execute("#{@git} pull -q ${1:-origin} #{branch}")
   end

   private def checkout(branch)
      puts("→ Checkout: #{branch}")
      execute("#{@git} checkout -q #{branch}")
   end
   
   private def pull(branch)
      puts("→ Pull: #{branch}")
      cmd = "#{@git} pull -q ${1:-origin} #{branch}"
      system(cmd)
   end

   private def fetch()
      sh = "#{@git} fetch --prune"
      puts("→ Fetching: #{sh}")
      system(sh)
   end
   
   private def execute(cmd)
      puts("  #{cmd}")
      system(cmd)
   end
end
