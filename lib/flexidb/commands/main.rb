require 'flexidb/engine'
module FlexiDB
  module Commands
    class Main < Command
      
      # Contribute to options
      def add_options(opt)
      end
      
      # Returns the command banner
      def banner
        "flexidb [options] URI"
      end
      
      # Runs the sub-class defined command
      def __run(requester_file, arguments)
        self.uri = arguments[0] if self.uri.nil? and arguments.size > 0
        FlexiDB::Engine.new(self.uri).__execute
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