require 'dbagile'
require 'dbagile/commands'
module DbAgile
  module Commands
    module API
      
      # Builds a command instance for a specific class
      def build_command(clazz, env)
        command = clazz.new(env)
        command
      end
      module_function :build_command
      
      # Builds options
      def build_options(options)
        case options
          when Array
            options
          when String
            options.split
          else
            raise ArgumentError, "Invalid options #{options}"
        end
      end
      module_function :build_options
      
      # Creates an API method for each subclass
      DbAgile::Commands::Command::subclasses.each do |subclass|
        command_name = DbAgile::Commands::Command::command_name_of(subclass)
        instance_eval <<-EOF
          def #{command_name}(options = [], env = DbAgile::Commands::Command::DEFAULT_ENVIRONMENT_CLASS.new)
            build_command(#{subclass.name}, env).run(__FILE__, build_options(options))
          end
        EOF
      end
      
    end # module API
  end # module Commands
end # module DbAgile
