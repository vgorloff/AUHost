# Reads a set number of lines from the top.
# Usage: File.head('path.txt')
class File
   def self.head(path, n = 1)
      open(path) do |f|
         lines = []
         n.times do
            line = f.gets || break
            lines << line
         end
         lines
      end
   end
end
