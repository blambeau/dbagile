require 'dbagile/engine'
module DbAgile
  module Commands
    class Main < Command
      
      # Database uri
      attr_accessor :uri
      
      # File to execute
      attr_accessor :file
      
      # The environment on which the engine will execute
      attr_accessor :env
      
      # Contribute to options
      def add_options(opt)
        opt.on("--uri=URI", "-u", "Database URI to use") do |value|
          self.uri = value
        end
        opt.on("--file=FILE", "-f", "Executes a given file on the engine") do |value|
          self.file = value
        end
      end
      
      # Returns the command banner
      def banner
        "dbagile [options] URI"
      end
      
      # Checks if an argument looks like an URI
      def looks_an_uri?(arg)
        /^[a-z]+:\/\// =~ arg
      end
      
      # Checks that a file is valid for reading
      def valid_read_file?(file)
        File.exists?(file) and File.file?(file) and File.readable?(file)
      end
      
      # Normalizes arguments
      def normalize_pending_arguments(arguments)
        case arguments.size
          when 0
          when 1
            arg = arguments[0]
            if looks_an_uri?(arg)
              self.uri = arg
            else
              self.file = arg
            end
          else
            exit(true)
        end
        if self.file
          self.env = ::DbAgile::Engine::DslEnvironment.new(File.read(self.file))
        else
          self.env = ::DbAgile::Engine::ConsoleEnvironment.new
        end
      end
      
      # Checks the arguments
      def check_command
        if file and not(valid_read_file?(file))
          exit("No such file #{file}", false) 
        end
      end
      
      # Executes the command
      def execute_command
        engine = DbAgile::Engine.new(self.env)
        engine.connect(self.uri) if self.uri
        if self.env.kind_of?(DbAgile::Engine::ConsoleEnvironment)
          engine.say("Welcome in dbagile #{::DbAgile::VERSION} interactive terminal.")
          engine.say("\n")
          engine.say('Type:  \c to connect a database')
          engine.say('       \h for help')
          engine.say('       \q to quit')
          engine.say("\n")
        end
        engine.execute
      end
      
      # Shows the content of a table
      def show_dataset(dataset)
        dataset.each do |row|
          puts row.inspect
        end
      end
      
    end # class Main
  end # module Commands
end # module DbAgile