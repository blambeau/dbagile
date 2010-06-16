require 'dbagile/engine/errors'
require 'dbagile/engine/environment'
require 'dbagile/engine/console_environment'
require 'dbagile/engine/dsl_environment'
require 'dbagile/engine/runner'
module DbAgile
  class Engine
    
    # Class ########################################################################

    # The environment
    attr_reader :env
    
    # Connection options
    attr_reader :options
    
    # Keeps the last error
    attr_reader :last_error
    
    # Creates an engine instance on top of a database
    def initialize(options = {})
      @options = options
    end
    
    # Basic commands start here ####################################################
    
    # Returns true if a database is currently connected, false otherwise.
    # Connected does not mean that the database pings, only that the underlying
    # database instance variable is not nil.
    def connected?
      not(@connection.nil?)
    end
    
    # Connects to a database
    def connect(uri)
      disconnect
      @connection = DbAgile::connect(uri, options)
      @connection.ping
      @connection
    end
    
    # Disconnects from the database
    def disconnect
      @connection.disconnect if @connection
      @connection = nil
    end
    
    # Flags the quit to true
    def quit
      @quit = true
    end
    
    # Returns the current connection
    def connection
      @connection
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
      raise NoSuchTableError, "No such table #{table_name}" unless @connection.has_table?(table_name)
    end
    
    # Asserts that a list of columns are valid for a given table. Raises a NoSuchColumnError 
    # otherwise
    def columns_exist!(table_name, columns)
      table_exists!(table_name)
      raise NoSuchColumnError, "No such columns #{table_name} :: #{columns.inspect}"\
        unless (columns - @connection.column_names(table_name)).empty?
    end
    
    # Raises an NoSuchCommandError with a friendly message
    def no_such_command!(cmdname)
      raise NoSuchCommandError, "No such command: #{cmdname}"
    end
    
    # Raises an InvalidCommandError with a friendly message
    def invalid_command!(line)
      raise InvalidCommandError, "Invalid command: #{line}"
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
      if @runner.respond_to?(cmd.to_s.to_sym)
        res = @runner.send(cmd, *args)
        res
      else
        no_such_command!(cmd)
      end
    end
    
    # Compiles an AstNode to a command with arguments
    def compile_and_execute(astnode)
      astnode.visit{|node, collected|
        case node.function
          when :'?'
            execute_command(node.literal, [])
          when :'_'
            node.literal
          else
            execute_command(node.function, collected)
        end
      }
    end
    
    # Executes
    def execute(source, &block)
      execute_on_env(DslEnvironment.new(source || block))
    end
    
    # Executes on a given environment
    def execute_on_env(env)
      @env = env
      env.engine = self
      @quit, @runner = false, Engine::Runner.new(self)
      until @quit
        begin
          env.next_command("dbagile=# ") do |cmd|
            case cmd
              when NilClass
              when Array
                execute_command(*cmd)
              when CodeTree::AstNode
                compile_and_execute(cmd)
            end
          end
        rescue Exception => ex
          @last_error = ex
          res = env.on_error(ex)
          raise res unless res.nil?
        end
      end
      @runner = nil
      env.save_history if env.respond_to?(:save_history)
    end
    
  end # class Engine
end # module DbAgile
