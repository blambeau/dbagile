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
      
      # Yields the block with each subclass in turn
      def each_subclass(&block)
        subclasses.each(&block)
      end
      
      #
      # Returns the command name of a given class
      #
      def command_name_of(clazz)
        /Command::([A-Za-z0-9]+)(::([A-Za-z0-9]+))?$/ =~ clazz.name
        if $3
          "#{$1.downcase}:#{$3.downcase}"
        else
          $1.downcase
        end
      end
    
      #
      # Returns the ruby name of a given class
      #
      def ruby_method_for(clazz)
        command_name_of(clazz).gsub(':', '_').to_sym
      end
    
      #
      # Returns a command instance for a given name and environment, 
      # returns nil if it cannot be found
      #
      def command_for(name_symbol_or_class, env)
        subclass = case name_symbol_or_class
          when String
            subclasses.find{|subclass| command_name_of(subclass) == name_symbol_or_class}
          when Symbol
            subclasses.find{|subclass| ruby_method_for(subclass) == name_symbol_or_class}
          when Class
            name_symbol_or_class
        end
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
