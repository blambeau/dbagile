module DbAgile
  class Command
    module Backend
      #
      # Execute a backend command
      #
      # Usage: dba #{command_name} [options] BACKEND COMMAND
      #
      class Exec < Command
        Command::build_me(self, __FILE__)
      
        # Backend name
        attr_accessor :backend
        
        # Command to execute
        attr_accessor :command
        
        # Dry-run ?
        attr_accessor :dry_run
      
        # Verbose ?
        attr_accessor :verbose
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--dry-run", "Only print what would be executed but don't do it") do
            self.dry_run = true
          end
          opt.on("--verbose", "-v", "Print additional information about sub-process execution") do
            self.verbose = 1
          end
          opt.on("--silent", "-s", "Be silent (don't print anything at all)") do
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
          self.backend, self.command = valid_argument_list!(arguments, Symbol, Symbol)
          self.backend = has_backend!(self.repository, self.backend)
        end
      
        #
        # Executes the command.
        #
        # @return [...] result of shell execution. If --dry-run was set, returns the
        #               string that whould have been executed without the option.
        #
        def execute_command
          cmd_text = backend.instantiate_command(command)
          if dry_run
            say(cmd_text) unless silent?
            cmd_text
          else
            # Execute the command
            pid = if silent? 
              Kernel.spawn(cmd_text, {:out => :close, :err => :close})
            else
              Kernel.spawn(cmd_text)
            end
            Process.wait(pid)
            
            # Save process status
            process_status = $?
            
            # Verbose information
            if verbose?
              say("exit status: #{process_status.exitstatus}", :magenta)
            end
            
            process_status
          end
        end
      
      end # class Exec
    end # module Backend
  end # class Command
end # module DbAgile