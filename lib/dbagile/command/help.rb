module DbAgile
  class Command
    #
    # Show help of a given command
    #
    # Usage: dba #{command_name} [--complete] COMMAND
    #
    class Help < Command
      Command::build_me(self, __FILE__)
      
      # Name of the configuration to add
      attr_accessor :command
      
      # Complete help?
      attr_accessor :complete
      
      # Returns command's category
      def category
        :dba
      end
      
      # Contribute to options
      def add_options(opt)
        opt.separator "\nOptions:"
        opt.on("--complete", "Provide complete command description") do
          self.complete = true
        end
      end
        
      # Normalizes the pending arguments
      def normalize_pending_arguments(arguments)
        self.command = valid_argument_list!(arguments, String)
        self.command = has_command!(self.command, environment)
      end
      
      # Executes the command
      def execute_command
        display(command.usage)
        display("\n")
        #
        display("Description:")
        display("  " + command.summary) unless command.summary.empty?
        #
        options = command.options.summarize
        unless options.empty?
          display(options.join)
          display("\n")
        end
        #
        description = command.description.to_s
        if complete
          if description.strip.empty?
            display("Sorry, no more information available yet")
          else
            display("Read more:")
            display(description.gsub(/^/, "  ")) 
            display("")
          end
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile