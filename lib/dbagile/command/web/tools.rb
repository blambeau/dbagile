module DbAgile
  class Command
    module Web
      #
      # Start the web tools
      #
      # Usage: dba #{command_name} [OPTIONS]
      #
      class Tools < Command
        Command::build_me(self, __FILE__)
      
        # Returns command's category
        def category
          :web
        end

        # Executes the command.
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