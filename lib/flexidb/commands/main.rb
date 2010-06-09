require 'flexidb/engine'
module FlexiDB
  module Commands
    class Main < Command
      
      # File to execute
      attr_reader :file
      
      # Contribute to options
      def add_options(opt)
        opt.on("--file=FILE", "-f", "Executes a given file on the engine") do |value|
          @file = value
        end
      end
      
      # Returns the command banner
      def banner
        "flexidb [options] URI"
      end
      
      # Runs the sub-class defined command
      def __run(requester_file, arguments)
        self.uri = arguments[0] if self.uri.nil? and arguments.size > 0
        if file
          exit("No such file #{file}", false) unless File.exists?(file) and File.file?(file) and File.readable?(file)
          env = FlexiDB::Engine::FileEnvironment.new(file)
        else
          env = FlexiDB::Engine::ConsoleEnvironment.new
        end
        FlexiDB::Engine.new(env, self.uri).execute
      end
      
      # Shows the content of a table
      def show_dataset(dataset)
        dataset.each do |row|
          puts row.inspect
        end
      end
      
    end # class Main
  end # module Commands
end # module FlexiDB