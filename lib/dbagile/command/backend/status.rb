module DbAgile
  class Command
    module Backend
      #
      # Check the status of a backend 
      #
      # Usage: dba #{command_name} BACKEND
      #
      class Status < Command
        Command::build_me(self, __FILE__)
      
        # Backend name
        attr_accessor :backend
        
        # Verbose ?
        attr_accessor :verbose
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--silent", "-s", "Be quiet, even silent (don't print anything at all)") do
            self.verbose = -1
          end
        end
        
        # Silent level activated?
        def silent?
          verbose && verbose < 0
        end
      
        # Verbosity level activated?
        def verbose?
          verbose && verbose > 0
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          self.backend = valid_argument_list!(arguments, String)
        end
      
        #
        # Executes the command.
        #
        # @return [...] true if the backend is running, false otherwise
        #
        def execute_command
          DbAgile::dba(environment){|dba| 
            status = dba.backend_exec ["--silent", self.backend, "status"]
            unless silent?
              if status != 0
                say("#{self.backend} seems not running!", :red)
              else
                say("#{self.backend} seems running!", :green)
              end
            end
            status == 0
          }
        end
      
      end # class Status
    end # module Backend
  end # class Command
end # module DbAgile