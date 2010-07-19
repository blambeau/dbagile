module DbAgile
  class Command
    class API
      include DbAgile::Environment::Delegator
      
      # Underlying environment
      attr_reader :environment
      
      # Creates an API instance for a given environment
      def initialize(environment)
        @environment = environment
      end
      
      ##############################################################################
      # Ruby commands
      ##############################################################################
      
      # Returns a dataset instance
      def dataset(name)
        environment.with_current_connection{|c|
          c.dataset(name)
        }
      end
      
      ##############################################################################
      # Console subcommands mimics
      ##############################################################################
      
      # Add API methods to Command class
      DbAgile::Command::each_subclass do |subclass|
        command_name = DbAgile::Command::command_name_of(subclass)
        module_eval <<-EOF
          def #{command_name}(*options)
            options = options.flatten
            command = DbAgile::Command::command_for(#{command_name.inspect}, environment)
            options = DbAgile::Command::build_command_options(options)
            command.unsecure_run(__FILE__, options)
          end
        EOF
      end
      
      # Delegates this api on a environment duplication
      def dup
        API.new(environment.dup)
      end
      
    end # class API
  end # class Command
end # module DbAgile
