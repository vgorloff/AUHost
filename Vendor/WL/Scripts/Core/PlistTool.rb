# Info
# - http://fgimian.github.io/blog/2015/06/27/a-simple-plistbuddy-tutorial/

class PlistTool

  def initialize(filePath)
    @exe = '/usr/libexec/PlistBuddy'
    @filePath = filePath
    if !File.exist?(filePath)
      clear()
    end
  end

  def addString(key, value)
    execute("Add :#{key} string \"#{value}\"")
  end

  def addBool(key, value)
    execute("Add :#{key} bool \"#{value}\"")
  end

  def addDict(key)
    execute("Add :#{key} dict")
  end

  def clear()
    execute('Clear dict')
  end

  # == PRIVATE ===
  def execute(command)
    cmd = "#{@exe} -c '#{command}' \"#{@filePath}\""
    system(cmd)
  end
end
