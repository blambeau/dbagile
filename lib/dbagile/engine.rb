require 'dbagile/engine/errors'
require 'dbagile/engine/environment'
require 'dbagile/engine/console_environment'
require 'dbagile/engine/dsl_environment'
require 'dbagile/engine/signature'
require 'dbagile/engine/command'
module DbAgile
  class Engine
    
    # Loading ######################################################################

    # All commands defined 
    COMMANDS = []
    
    # Install all commands now
    DbAgile::Engine::Command::constants.each do |c|
      # find the command, bypass non commands
      c = DbAgile::Engine::Command::const_get(c)
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
    
    # Keeps the last error
    attr_reader :last_error
    
    # Creates an engine instance on top of a database
    def initialize(env = ConsoleEnvironment.new)
      @env = env
      env.engine = self unless env.nil?
    end
    
    # Basic commands start here ####################################################
    
    # Returns true if a database is currently connected, false otherwise.
    # Connected does not mean that the database pings, only that the underlying
    # database instance variable is not nil.
    def connected?
      not(database.nil?)
    end
    
    # Connects to a database
    def connect(db)
      disconnect
      @database = DbAgile::connect(db)
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
    
    # Error support ################################################################
    
    # Asserts that a database is connected. Raises a NoDatabaseConnectedError 
    # otherwise.
    def connected!
      raise NoDatabaseError unless connected?
    end
    
    # Asserts that a table exists. Raises a NoSuchTableError otherwise
    # otherwise.
    def table_exists!(table_name)
      raise NoSuchTableError, "No such table #{table_name}" unless database.has_table?(table_name)
    end
    
    # Asserts that a list of columns are valid for a given table. Raises a NoSuchColumnError 
    # otherwise
    def columns_exist!(table_name, columns)
      table_exists!(table_name)
      raise NoSuchColumnError, "No such columns #{table_name} :: #{columns.inspect}"\
        unless (columns - database.column_names(table_name)).empty?
    end
    
    # Raises an NoSuchCommandError with a friendly message
    def no_such_command!(cmdname)
      raise NoSuchCommandError, "No such command: #{cmdname}"
    end
    
    # Raises an InvalidCommandError with a friendly message
    def invalid_command!(line)
      raise InvalidCommandError, "Invalid command: #{line}"
    end
    
    # Commands #####################################################################
    
    #
    # Find a command by its name. Yields the block with found command if a block is
    # given. 
    #
    # @param name [Symbol|String] a command name
    # @return the command when no block is given, block result otherwise.
    # @raise ArgumentError if the command cannot be found
    #
    def find_command(name)
      cmd = COMMANDS.find{|c| c.names.include?(name.to_s)}
      no_such_command!(name) if cmd.nil?
      block_given? ? yield(cmd) : cmd
    end
    
    # Yields the block with each command in turn
    def each_command(sorted_by_name = false, &block)
      sorted_by_name ? COMMANDS.sort{|cmd1,cmd2| cmd1.name.to_s <=> cmd2.name.to_s}.each(&block) : COMMANDS.each(&block)
    end
    
    #
    # Finds a command based on a name, find the execution method through signature
    # matching.
    #
    # @return [Command, Symbol, Array] a triple [cmd, execution_method, args]
    # @raise ArgumentError if the command cannot be found or the signature does 
    #         not match
    #  
    def prepare_command_exec(command_name, args)
      cmd = find_command(command_name)
      cmd.signatures.each_with_index do |s, i|
        next unless hash_args = s.match(args)
        new_args = s.match_to_args(hash_args)
        return [cmd, "execute_#{i+1}".to_sym, new_args]
      end
      execute_command('help', [command_name])
      invalid_command!("#{command_name} #{args.inspect}")
    end

    # Env delegate #################################################################
    
    # Delegated to env
    def ask(prompt, &continuation)
      env.ask(prompt, &continuation)
    end
    
    # Delegated to env
    def say(something, color = nil)
      env.say(something, color)
    end
    
    # Delegated to env
    def display(something)
      env.display(something)
    end
    
    # Raises an error
    def error(message)
      message.kind_of?(Exception) ? raise(message) : raise(EngineError, message)
    end
    
    # Execution ####################################################################
    
    # Executes a specific command
    def execute_command(cmd, args)
      cmd, method, args = prepare_command_exec(cmd, args || [])
      return unless cmd
      res = cmd.send(method, *args.unshift(self))
      env.say(res.inspect) unless res.nil?
    end
    
    # Executes on a given environment
    def execute
      @quit = false
      until @quit
        begin
          env.next_command("dbagile=# ") do |cmd|
            execute_command(*cmd) if cmd
          end
        rescue Exception => ex
          @last_error = ex
          res = env.on_error(ex)
          raise res unless res.nil?
        end
      end
      env.save_history if env.respond_to?(:save_history)
    end
    
  end # class Engine
end # module DbAgile
