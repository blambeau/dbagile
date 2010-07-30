module DbAgile
  module FileSystemTools
    
    # Returns a friendly path for display
    def friendly_path(path, from)
      from, path = Pathname.new(from), Pathname.new(path)
      if path.to_s[0...from.to_s.length] == from.to_s
        "~/#{path.relative_path_from(from)}"
      else
        nil
      end
    end
    
    # Returns a friendly path, no matter what happens
    def friendly_path!(path)
      friendly_path(path, ENV['HOME']) or
      friendly_path(path, File.expand_path('.')) or
      path
    end
    
    extend(FileSystemTools)
  end # module FileSystemTools
end # module DbAgile
    
