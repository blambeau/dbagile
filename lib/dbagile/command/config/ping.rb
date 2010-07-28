module DbAgile
  class Command
    module Config
      #
      # Ping a configuration (current one by default)
      #
      # Usage: dba #{command_name} [CONFIG]
      #
      class Ping < Command
        Command::build_me(self, __FILE__)
      
        # Name of the configuration to ping
        attr_accessor :match
      
        # Returns command's category
        def category
          :config
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          if arguments.empty?
            self.match = nil
          else
            self.match = valid_argument_list!(arguments, Symbol)
            self.match = valid_database_name!(self.match)
          end
        end
      
        # Executes the command
        def execute_command
          cf = with_repository do |repository|
        
            config = has_database!(repository, self.match)
        
            # Make the job now
            begin
              with_connection(config){|c| c.ping}
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
      
      end # class Ping
    end # module Config
  end # class Command
end # module DbAgile