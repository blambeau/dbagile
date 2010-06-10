module DbAgile
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
          names.nil? ? nil : names.last
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
          signatures << DbAgile::Engine::Signature.new
          yield if block_given?
        end
      
        # Adds an argument to the current signature
        def argument(name, *checks, &block)
          @signatures.last.add_argument(name, *checks, &block)
        end
    
        # Checks that command installation is correct
        def check
          raise "Missing command name on #{self.class}" unless name
          raise "Missing command signatures on #{self.class}" if (signatures.nil? or signatures.empty?)
          raise "Missing command synopsis on #{self.class}" unless synopsis
        end
      
      end # DSL methods
      
      # Returns command names
      def names
        self.class.names
      end
      
      # Returns command name
      def name
        self.class.name
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
end # module DbAgile
require 'dbagile/engine/command/connect'
require 'dbagile/engine/command/define'
require 'dbagile/engine/command/disconnect'
require 'dbagile/engine/command/display'
require 'dbagile/engine/command/help'
require 'dbagile/engine/command/insert'
require 'dbagile/engine/command/ping'
require 'dbagile/engine/command/quit'
require 'dbagile/engine/command/use'
require 'dbagile/engine/command/sql'
require 'dbagile/engine/command/backtrace'
require 'dbagile/engine/command/key'
