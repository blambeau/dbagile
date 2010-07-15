require 'dbagile'
require 'dbagile/commands'
module DbAgile
  module Commands
    module API
      
      # Builds a command instance for a specific class
      def build_command(clazz, buffer = "")
        command = clazz.new
        command.buffer = buffer
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
        instance_eval <<-EOF
          def #{DbAgile::Commands::Command::command_name_of(subclass)}(options = [], buffer = "")
            build_command(#{subclass.name}, buffer).run(__FILE__, build_options(options))
            buffer
          end
        EOF
      end
      
    end # module API
  end # module Commands
end # module DbAgile
