module DbAgile
  class Command
    #
    # Show help of a given command
    #
    # Usage: dba #{command_name} COMMAND
    #
    class Help < Command
      Command::build_me(self, __FILE__)
      
      # Command name
      attr_accessor :command
        
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.command = valid_argument_list!(arguments, String)
        self.command = has_command!(self.command, environment)
      end
      
      # Executes the command
      def execute_command
        flush(command.usage)
        flush("\n")
        #
        flush("Description:")
        flush("")
        flush("  " + command.summary)
        #
        options = command.options.summarize
        unless options.empty?
          flush(options.join)
          flush("\n")
        else
          flush("\n")
        end
        #
        description = command.description.to_s
        if description.strip.empty?
          flush("Sorry, no more information available yet")
        else
          flush("Detailed documentation:")
          flush("")
          flush(description.gsub(/^/, "  ")) 
          flush("")
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile