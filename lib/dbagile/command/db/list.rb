module DbAgile
  class Command
    module Db
      #
      # List available databases (found in ~/.dbagile)
      #
      # Usage: dba #{command_name}
      #
      class List < Command
        Command::build_me(self, __FILE__)
      
        # Verbose ?
        attr_accessor :verbose
      
        # Sets the default options
        def set_default_options
          @verbose = false
        end
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--verbose", "-v", "Displays full contents of ~/.dbagile file") do |value|
            self.verbose = true
          end
        end
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Repository] the repository instance
        #
        def execute_command
          with_repository do |repository|

            if verbose
              display(repository.to_yaml)
            else
              unless repository.empty?
                display("Available databases are (#{repository.file}):")
                repository.each do |database|
                  msg = repository.current?(database) ? "  -> " : " "*5
                  msg += database.name.to_s.ljust(15)
                  msg += " "
                  msg += database.uri
                  display(msg)
                end
              else
                say("No database found. Checks ~/.dbagile", :red)
              end
            end

            repository
          end
        end
      
      end # class List
    end # module Db
  end # class Command
end # module DbAgile