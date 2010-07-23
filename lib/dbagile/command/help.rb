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
        say(command.usage.to_s)
        say("")
        say("Description:")
        say("  " + command.summary.to_s)
        say(command.options.summarize.join)
        say("")
        if complete
          say("Read more:")
          say(command.description.to_s.gsub(/^/, "  ")) 
          say("")
        end
      end
      
    end # class List
  end # class Command
end # module DbAgile