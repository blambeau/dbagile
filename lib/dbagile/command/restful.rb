module DbAgile
  class Command
    #
    # Starts the restful server
    #
    class Restful < Command
      
      # Returns the command banner
      def banner
        "Usage: dba restful [OPTIONS]"
      end
      
      # Returns command's category
      def category
        :restful
      end

      # Short help
      def short_help
        "Starts the restful server"
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
        require 'dbagile/restful'
        require 'dbagile/restful/server'
        DbAgile::Restful::Server.new(environment).start.join
      rescue Interrupt => ex
        environment.say("Ciao!")
      end
      
    end # class List
  end # class Command
end # module DbAgile