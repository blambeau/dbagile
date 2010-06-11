require 'dbagile/engine'
module DbAgile
  module Commands
    class Main < Command
      
      # Database uri
      attr_accessor :uri
      
      # File to execute
      attr_accessor :file
      
      # Trace sql?
      attr_accessor :trace_sql
      
      # Does only trace SQL?
      attr_accessor :trace_only
      
      # Output of traces and engine display
      attr_accessor :output
      
      # The environment on which the engine will execute
      attr_accessor :env
      
      # The connection options
      attr_accessor :connection_options
      
      # Contribute to options
      def add_options(opt)
        opt.on("--uri=URI", "-u", "Database URI to use") do |value|
          self.uri = value
        end
        opt.on("--file=FILE", "-f", "Executes a given file on the engine") do |value|
          self.file = value
        end
        opt.on("--trace-sql", "Trace SQL statements") do
          self.trace_sql = true
          self.trace_only = false
        end
        opt.on("--trace-only", "Only trace SQL statements, do not update database for real") do
          self.trace_sql = true
          self.trace_only = true
        end
        opt.on("--output=FILE", "-o", "Redirect output to a file") do |value|
          self.output = value
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
        
        # Output buffer
        self.output = STDOUT unless self.output
        self.output = File.open(output, 'w') if self.output.kind_of?(String)
        
        # The environment
        if self.file
          self.env = ::DbAgile::Engine::DslEnvironment.new(File.read(self.file))
        else
          self.env = ::DbAgile::Engine::ConsoleEnvironment.new
        end
        
        # Connection options
        self.connection_options = {
          :trace_sql    => trace_sql, 
          :trace_only   => trace_only,
          :trace_buffer => trace_sql ? output : nil
        }
      end
      
      # Checks the arguments
      def check_command
        if file and not(valid_read_file?(file))
          exit("No such file #{file}", false) 
        end
      end
      
      # Executes the command
      def execute_command
        engine = DbAgile::Engine.new(self.env, connection_options)
        engine.connect(self.uri) if self.uri
        if self.env.kind_of?(DbAgile::Engine::ConsoleEnvironment)
          engine.say("Welcome in dbagile #{::DbAgile::VERSION} interactive terminal.")
          engine.say("\n")
          engine.say('Type:  \c to connect a database')
          engine.say('       \h for help')
          engine.say('       \q to quit')
          engine.say("\n")
          engine.execute
        else
          begin
            engine.execute
          rescue Exception => ex
            puts ex.message
          end
        end
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