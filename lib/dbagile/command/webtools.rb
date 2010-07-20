module DbAgile
  class Command
    #
    # Starts the web tools
    #
    class WebTools < Command
      
      # Returns the command banner
      def banner
        "Usage: dba webtools [OPTIONS]"
      end
      
      # Returns command's category
      def category
        :restful
      end

      # Short help
      def short_help
        "Starts the webtools server"
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
      
    end # class WebTools
  end # class Command
end # module DbAgile