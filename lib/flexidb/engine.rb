require 'flexidb/engine/highline_environment'
require 'flexidb/engine/command'
module FlexiDB
  class Engine
    
    # Current database on which this engine is connected
    attr_reader :database
    
    # Creates an engine instance on top of a database
    def initialize(db = nil)
      __connect(db) if db
    end
    
    # Connects to a database
    def __connect(db)
      __disconnect
      @database = FlexiDB::connect(db)
    end
    
    # Disconnects from the database
    def __disconnect
      database.disconnect if database
    end
    
    # Flags the quit to true
    def __quit
      @quit = true
    end
    
    # Executes on a given environment
    def __execute(env = HighlineEnvironment.new)
      @quit = false
      until @quit
        next if (command = env.ask("flexidb=# ").strip).empty?
        begin
          if /^([^\s]+)\s*(.*)$/ =~ command
            cmd, args = $1, Kernel.eval("[#{$2}]")
            if self.respond_to?(cmd)
              self.send(cmd, *([self, env] + args))
            else
              env.error("Uknown command #{command}")
            end
          else
            env.error("Uknown command #{command}")
          end
        rescue => ex
          env.error(ex.message)
        end
      end
    end
    
    # Install all commands now
    FlexiDB::Engine::Command::constants.each do |c|
      c = FlexiDB::Engine::Command::const_get(c)
      next unless c.kind_of?(Class)
      next unless c.superclass == Command
      define_method(c.command_name) do |*args|
        c.new.execute(*args)
      end
    end
    
  end # class Engine
end # module FlexiDB
