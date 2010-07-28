module DbAgile
  class Command
    module Config
      #
      # List available database configurations (found in ~/.dbagile)
      #
      # Usage: dba #{command_name}
      #
      class List < Command
        Command::build_me(self, __FILE__)
      
        # Verbose ?
        attr_accessor :verbose
      
        # Returns command's category
        def category
          :config
        end
      
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
        # @return [DbAgile::Core::Repository] the configuration file instance
        #
        def execute_command
          with_config_file do |config_file|

            if verbose
              display(config_file.inspect)
            else
              unless config_file.empty?
                display("Available databases are (#{config_file.file}):")
                config_file.each do |config|
                  msg = config_file.current?(config) ? "  -> " : " "*5
                  msg += config.name.to_s.ljust(15)
                  msg += " "
                  msg += config.uri
                  display(msg)
                end
              else
                say("No database configuration found. Checks ~/.dbagile", :red)
              end
            end

            config_file
          end
        end
      
      end # class List
    end # module Config
  end # class Command
end # module DbAgile