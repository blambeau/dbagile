module DbAgile
  class Command
    module Db
      #
      # List available databases in current repository
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
              flush("Available databases are (#{repository.friendly_path}):")
              repository.each do |database|
                msg = repository.current?(database) ? "  -> " : " "*5
                msg += database.name.to_s.ljust(15)
                msg += " "
                msg += database.uri
                flush(msg)
              end
            else
              say("No database found. Check #{repository.friendly_path}", :magenta)
            end

            repository
          end
        end
      
      end # class List
    end # module Db
  end # class Command
end # module DbAgile