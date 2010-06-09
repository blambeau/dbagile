require 'flexidb/engine/console_environment'
require 'flexidb/engine/command'
module FlexiDB
  class Engine
    
    # All commands defined 
    COMMANDS = {}
    
    # Command shortcuts
    SHORTCUTS = {
      '\q' => :quit,
      '\h' => :help
    }
    
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
      @database.adapter.ping
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
    def __execute(env = ConsoleEnvironment.new)
      @quit = false
      until @quit
        next if (command = env.ask("flexidb=# ").strip).empty?
        begin
          if SHORTCUTS.key?(command)
            self.send(SHORTCUTS[command], self, env)
          elsif /^([^\s]+)\s*(.*)$/ =~ command
            cmd, args = $1, $2.strip
            if self.respond_to?(cmd)
              args = args.empty? ? [self, env] : [self, env, args]
              self.send(cmd, *args)
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
      env.save_history if env.respond_to?(:save_history)
    end
    
    # Install all commands now
    FlexiDB::Engine::Command::constants.each do |c|
      c = FlexiDB::Engine::Command::const_get(c)
      next unless c.kind_of?(Class)
      next unless c.superclass == Command
      COMMANDS[c.command_name] = c.new
      define_method(c.command_name) do |*args|
        COMMANDS[c.command_name].execute(*args)
      end
    end
    
  end # class Engine
end # module FlexiDB
