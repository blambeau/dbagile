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
        method_name = DbAgile::Command::ruby_method_for(subclass)
        module_eval <<-EOF
          def #{method_name}(*options)
            options = options.flatten
            command = DbAgile::Command::command_for(#{subclass.name}, environment)
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
