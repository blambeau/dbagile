module DbAgile
  class Command
    #
    # Replay a previous history command (last one by default)
    #
    # Usage: dba #{command_name} [NUMBER]
    #
    class Replay < Command
      Command::build_me(self, __FILE__)
      
      # Command number to replay
      attr_accessor :number
      
      # Returns command's category
      def category
        :dba
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
        DbAgile::dba(environment){|dba| dba.dba(environment.from_command_line(command)) }
      end
      
    end # class List
  end # class Command
end # module DbAgile