require 'flexidb/engine/console_environment'
require 'flexidb/engine/signature'
require 'flexidb/engine/command'
module FlexiDB
  class Engine
    
    # Loading ######################################################################

    # All commands defined 
    COMMANDS = []
    
    # Install all commands now
    FlexiDB::Engine::Command::constants.each do |c|
      # find the command, bypass non commands
      c = FlexiDB::Engine::Command::const_get(c)
      next unless c.kind_of?(Class)
      next unless c.superclass == Command
      
      # Adds the command instance now
      COMMANDS << c.new
    end
    
    # Class ########################################################################

    # The environment
    attr_reader :env
    
    # Current database on which this engine is connected
    attr_reader :database
    
    # Creates an engine instance on top of a database
    def initialize(env = ConsoleEnvironment.new, db = nil)
      @env = env
      connect(db) if db
    end
    
    # Basic commands start here ####################################################
    
    # Connects to a database
    def connect(db)
      disconnect
      @database = FlexiDB::connect(db)
      @database.adapter.ping
    end
    
    # Disconnects from the database
    def disconnect
      database.disconnect if database
    end
    
    # Flags the quit to true
    def quit
      @quit = true
    end
    
    # Commands #####################################################################
    
    #
    # Find a command by its name. Yields the block with found command if a block is
    # given. 
    #
    # @param name [Symbol|String] a command name
    # @return the command when no block is given, block result otherwise.
    # @raises ArgumentError if the command cannot be found
    #
    def find_command(name)
      cmd = COMMANDS.find{|c| c.names.include?(name.to_s)}
      raise ArgumentError, "No such command #{name}" if cmd.nil?
      block_given? ? yield(cmd) : cmd
    end
    
    # Yields the block with each command in turn
    def each_command(&block)
      COMMANDS.each(&block)
    end

    # Environment ##################################################################
    
    # Delegated to @env
    def ask(what)
      env.ask(what)
    end
    
    # Delegated to @env
    def say(what)
      env.say(what)
    end
    
    # Delegated to @env
    def error(message)
      env.error(message)
    end
    
    # Execution ####################################################################
    
    # Executes on a given environment
    def execute()
    end
    
  end # class Engine
end # module FlexiDB
