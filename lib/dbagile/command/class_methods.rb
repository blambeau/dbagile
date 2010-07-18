module DbAgile
  class Command
    module ClassMethods
      
      #
      # Tracks subclasses for maintaining subcommand list
      #
      def inherited(subclass) 
        super
        @subclasses ||= [] 
        @subclasses << subclass 
      end 
      
      #
      # Returns the array of known command sub-classes
      #
      def subclasses 
        @subclasses 
      end 
      
      #
      # Returns the command name of a given class
      #
      def command_name_of(clazz)
        /::([A-Za-z0-9]+)$/ =~ clazz.name
        $1.downcase
      end
    
      #
      # Returns a command instance for a given name and environment, 
      # returns nil if it cannot be found
      #
      def command_for(name, env)
        subclass = subclasses.find{|subclass| command_name_of(subclass).to_s == name.to_s}
        subclass.nil? ? nil : subclass.new(env)
      end

      #
      # Builds command options
      #
      def build_command_options(options)
        case options
          when Array
            options
          when String
            options.split
          else
            raise ArgumentError, "Invalid options #{options}"
        end
      end
      
    end # module ClassMethods
  end # class Command
end # module DbAgile
