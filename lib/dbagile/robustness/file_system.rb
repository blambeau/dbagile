module DbAgile
  module Robustness
    module FileSystem
      
      # Asserts that a directory exists, is readable and writable
      def valid_rw_directory!(dir, 
                              msg = "Unable to access #{dir} in read/write", 
                              error_class = IOError)
        unless File.directory?(dir) &&
               File.readable?(dir) &&
               File.writable?(dir)
          raise error_class, msg, caller
        end
        dir
      end

      # Asserts that a file exists, is readable and writable
      def valid_rw_file!(file, 
                         msg = "Unable to access #{file} in read/write", 
                         error_class = IOError)
        unless File.file?(file) &&
               File.readable?(file) &&
               File.writable?(file)
          raise error_class, msg, caller
        end
        file
      end
      
      # Asserts that a file exists and is readable.
      def valid_r_file!(file, 
                        msg = "Unable to access #{file} in read", 
                        error_class = IOError)
        unless File.file?(file) &&
               File.readable?(file)
          raise error_class, msg, caller
        end
        file
      end
      
      # Asserts that a directory does not exists
      def unexisting_directory!(dir, 
                                msg = "Directory #{dir} already exists, use --force", 
                                error_class = IOError)
        if File.exists?(dir)
          raise error_class, msg, caller
        end
        dir
      end
      
    end # module FileSystem
    extend(FileSystem)
  end # module Robustness
end # module DbAgile