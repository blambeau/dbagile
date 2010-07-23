module DbAgile
  class Command
    module Web
      #
      # Starts the web tools
      #
      class Tools < Command
      
        # Returns the command banner
        def banner
          "Usage: dba #{command_name} [OPTIONS]"
        end
      
        # Returns command's category
        def category
          :web
        end

        # Short help
        def short_help
          "Starts the web tools"
        end
      
        # Sets the default options
        def set_default_options
        end
      
        # Contribute to options
        def add_options(opt)
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Configuration] the created configuration
        #
        def execute_command
          require 'dbagile/restful/server'
          DbAgile::Restful::Server.new(environment).start.join
        rescue Interrupt => ex
          environment.say("Ciao!")
        end
      
      end # class Tools
    end # module Web
  end # class Command
end # module DbAgile