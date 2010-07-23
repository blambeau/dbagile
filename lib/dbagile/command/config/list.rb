module DbAgile
  class Command
    module Config
      #
      # List available database handler listed in ~/.dbagile file
      #
      class List < Command
      
        # Verbose ?
        attr_accessor :verbose
      
        # Returns command's category
        def category
          :config
        end
      
        # Returns the command banner
        def banner
          "Usage: dba #{command_name}"
        end

        # Short help
        def short_help
          "List available database configurations (found in ~/.dbagile)"
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
        # @return [DbAgile::Core::Configuration::File] the configuration file instance
        #
        def execute_command
          with_config_file do |config_file|

            if verbose
              display(config_file.inspect)
            else
              unless config_file.empty?
                say("Available databases are:")
                config_file.each do |config|
                  msg = config_file.current?(config) ? "  -> " : " "*5
                  msg += config.name.to_s.ljust(15)
                  msg += " "
                  msg += config.uri
                  display(msg)
                end
              else
                say("No database configuration found. Checks ~/.dbagile")
              end
            end

            config_file
          end
        end
      
      end # class List
    end # module Config
  end # class Command
end # module DbAgile