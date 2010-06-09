module FlexiDB
  class Engine
    class Command

      # DSL methods
      class << self

        # Sets command names
        def names(*names)
          if names.empty?
            @names
          else
            @names = names
          end
        end
        
        # Returns offical command name
        def name
          names.last
        end
        
        # Sets synopsis
        def synopsis(synopsis = nil)
          if synopsis.nil?
            @synopsis
          else
            @synopsis = synopsis
          end
        end
      
        # Returns method signatures
        def signatures
          @signatures ||= []
        end
      
        # Adds a signature for the command
        def signature
          signatures << FlexiDB::Engine::Signature.new
          yield if block_given?
        end
      
        # Adds an argument to the current signature
        def argument(name, type, &check)
          @signatures.last.add_argument(name, type, check)
        end
    
      end # DSL methods
      
      # Returns command names
      def names
        self.class.names
      end
      
      # Returns command name
      def name
        names.last
      end
      
      # Returns command signature
      def signatures
        self.class.signatures
      end
      
      # Returns command banner
      def banner
        name = self.name
        signatures.collect{|s| "#{s.banner(name)}"}
      end
      
      # Returns command's synopsis
      def synopsis
        self.class.synopsis
      end
      
    end # class Command
  end # class Engine
end # module FlexiDB
require 'flexidb/engine/command/connect'
require 'flexidb/engine/command/define'
require 'flexidb/engine/command/disconnect'
require 'flexidb/engine/command/display'
require 'flexidb/engine/command/help'
require 'flexidb/engine/command/insert'
require 'flexidb/engine/command/ping'
require 'flexidb/engine/command/quit'
require 'flexidb/engine/command/use'
require 'flexidb/engine/command/sql'
