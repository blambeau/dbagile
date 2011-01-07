module DbAgile
  class Command
    module Backend
      #
      # List available backends in current repository
      #
      # Usage: dba #{command_name}
      #
      class List < Command
        Command::build_me(self, __FILE__)
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Repository] the repository instance
        #
        def execute_command
          with_repository do |repository|

            unless repository.empty?
              flush("Available backends are (#{repository.friendly_path}):")
              repository.each_backend do |backend|
                msg = " "*5
                msg += backend.name.to_s.ljust(15)
                msg += " "
                msg += backend.config.inspect
                flush(msg)
              end
            else
              say("No backend found. Check #{repository.friendly_path}", :magenta)
            end

            repository
          end
        end
      
      end # class List
    end # module Backend
  end # class Command
end # module DbAgile