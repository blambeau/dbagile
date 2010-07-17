module DbAgile
  class Command
    #
    # Display command history
    #
    class Replay < Command
      
      # Command number to replay
      attr_accessor :number
      
      # Returns command's category
      def category
        :dba
      end
      
      # Returns the command banner
      def banner
        "usage: dba replay [NUMBER]"
      end

      # Short help
      def short_help
        "Replay a previous history command (last one by default)"
      end
      
      # Overrided to avoid parsing options (otherwise -1, -2 will not work)
      def unsecure_run(requester_file, argv)
        if argv.empty?
          self.number = -1
        else
          self.number = valid_argument_list!(argv, Integer)
        end
        execute_command
      end

      # Executes the command
      def execute_command
        command = environment.history[self.number]
        say("Replaying #{command.inspect}")
        DbAgile::Command::dba(environment.from_command_line(command), environment)
      end
      
    end # class List
  end # class Command
end # module DbAgile