module DbAgile
  class Command
    module ClassMethods
      
      # The command summary
      attr_reader :summary
      
      # The command banner
      attr_reader :usage
      
      # Command description
      attr_reader :description
      
      # Helper to generate command classes 
      def build_me(command_class, file)
        rdoc = DbAgile::RubyTools::rdoc_file_paragraphs(file)
        summary, usage, description = rdoc.shift, rdoc.shift, rdoc.join("\n")
        command_class.instance_eval{
          @summary     = summary
          @usage       = usage.gsub('#{command_name}', command_class.command_name)
          @description = description
        }
      end
      
      # Tracks subclasses for maintaining subcommand list
      def inherited(subclass) 
        super
        @subclasses ||= [] 
        @subclasses << subclass 
      end 
      
      # Returns the array of known command sub-classes
      def subclasses 
        @subclasses 
      end
      
      # Yields the block with each subclass in turn
      def each_subclass(&block)
        subclasses.each(&block)
      end
      
      # Returns the command name of a given class
      def command_name_of(clazz)
        name = DbAgile::RubyTools::unqualified_class_name(clazz)
        name = name.gsub(/[A-Z]/){|x| "-#{x.downcase}"}[1..-1]
        parent_module = DbAgile::RubyTools::parent_module(clazz)
        if parent_module == DbAgile::Command
          name
        else
          parent_name = DbAgile::RubyTools::unqualified_class_name(parent_module)
          "#{parent_name.downcase}:#{name}"
        end
      end
      
      # Returns command name
      def command_name
        command_name_of(self)
      end
    
      # Returns the ruby name of a given class
      def ruby_method_for(clazz)
        command_name_of(clazz).gsub(/[:\-]/, '_').to_sym
      end
    
      # Returns a command instance for a given name and environment, 
      # returns nil if it cannot be found
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

      # Builds command options
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
