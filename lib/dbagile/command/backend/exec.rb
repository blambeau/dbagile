module DbAgile
  class Command
    module Backend
      #
      # Executes a backend command
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
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on("--dry-run", "Only print what would be executed but don't do it") do
            self.dry_run = true
          end
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
            say cmd_text
          else
            Kernel.exec cmd_text
          end
        end
      
      end # class Exec
    end # module Backend
  end # class Command
end # module DbAgile