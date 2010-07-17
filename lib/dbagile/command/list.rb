module DbAgile
  class Command
    #
    # List available database handler listed in ~/.dbagile file
    #
    class List < Command
      
      # Verbose ?
      attr_accessor :verbose
      
      # Returns command's category
      def category
        :configuration
      end
      
      # Returns the command banner
      def banner
        "usage: dba list"
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
      
      # Executes the command
      def execute_command
        with_config_file do |config_file|

          if verbose
            display(config_file.inspect)
          else
            unless config_file.empty?
              say("Available databases are:")
              config_file.each do |config|
                msg = config_file.current?(config) ? "  -> " : " "*5
                msg += align(config.name,15)
                msg += " "
                msg += config.uri
                display(msg)
              end
            else
              say("No database configuration found. Checks ~/.dbagile")
            end
          end

        end
      end
      
    end # class List
  end # class Command
end # module DbAgile