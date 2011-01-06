module DbAgile
  class Command
    module Robust
      include DbAgile::Core::IO::Robustness
      
      # Raises an OptionParser::InvalidArgument
      def bad_argument_list!(rest, expected_name = nil)
        if rest.empty?
          raise OptionParser::MissingArgument, "#{expected_name}"
        else
          raise OptionParser::InvalidArgument, "#{rest.join(' ')}"
        end
      end
      
      # Raises an OptionParser::AmbiguousArgument
      def ambigous_argument_list!
        raise OptionParser::AmbiguousArgument, "Ambiguous options"
      end
      
      # Parses pending arguments, assert that it contains exactly
      # types.size arguments, and convert them to types.
      def valid_argument_list!(rest, *types)
        if rest.size == types.size
          result = rest.zip(types).collect do |arg, type|
            if String == type
              arg.to_s
            elsif Symbol == type
              arg.to_sym
            elsif Integer
              arg.to_i
            else
              raise OptionParser::InvalidArgument, arg
            end
          end
          result.size == 1 ? result[0] : result
        elsif rest.size < types.size
          raise OptionParser::MissingArgument
        else
          raise OptionParser::NeedlessArgument, rest
        end
      end
      
      # Asserts that an argument matches some candidates or
      # raises a OptionParser::InvalidArgument error.
      def is_in!(name, value, candidates)
        value = valid_argument_list!([ value ], candidates.first.class)
        unless candidates.include?(value)
          raise OptionParser::InvalidArgument, "Expected one of #{candidates.inspect} for #{name}"
        end
        value
      end
      
      # Checks that a file exists and can be read or raises an IO error
      def valid_read_file!(file)
        raise IOError, "Unable to read #{file}" unless File.file?(file) and File.readable?(file)
        file
      end
        
      #
      # Asserts that a command exists or raises a NoSuchCommandError.
      # 
      # @return [DbAgile::Command] the command instance
      #
      def has_command!(name, env)
        cmd = DbAgile::Command.command_for(name, env)
        if cmd.nil?
          DbAgile::Command::CATEGORIES.each{|c|
            cmd = DbAgile::Command.command_for("#{c}:#{name}", env)
            return cmd if cmd
          }
          raise DbAgile::NoSuchCommandError, "No such command #{name.inspect}" 
        else
          cmd
        end
      end
      
      #
      # Raises a DbAgile::AssumptionFailedError with a specific message
      #
      def assumption_error!(msg)
        raise DbAgile::AssumptionFailedError, msg
      end
      
    end # module Robust
  end # class Command 
end # module DbAgile