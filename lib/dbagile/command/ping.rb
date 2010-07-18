module DbAgile
  class Command
    #
    # Pings a configuration
    #
    class Ping < Command
      
      # Name of the configuration to ping
      attr_accessor :match
      
      # Returns command's category
      def category
        :configuration
      end
      
      # Returns the command banner
      def banner
        "usage: dba ping [CONFIG]"
      end

      # Short help
      def short_help
        "Ping a configuration (current one by default)"
      end
      
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        if arguments.empty?
          self.match = nil
        else
          self.match = valid_argument_list!(arguments, Symbol)
          self.match = valid_configuration_name!(self.match)
        end
      end
      
      # Executes the command
      def execute_command
        cf = with_config_file do |config_file|
        
          config = has_config!(config_file, self.match)
        
          # Make the job now
          begin
            config.connect.ping
            say("Ping ok (#{config.uri})")
            config
          rescue StandardError => ex
            say("Ping KO (#{config.uri})", :red)
            display(ex.message)
            ex
          end
          
        end
        cf
      end
      
    end # class List
  end # class Command
end # module DbAgile