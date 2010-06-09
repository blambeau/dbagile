module FlexiDB
  class Engine
    class Command
    
      # Returns the command name
      def self.command_name
        self.name =~ /([A-Za-z]+)$/
        $1.downcase.to_sym
      end
    
    end # class Command
  end # class Engine
end # module FlexiDB
require 'flexidb/engine/command/quit'
require 'flexidb/engine/command/ping'
require 'flexidb/engine/command/connect'
require 'flexidb/engine/command/display'
require 'flexidb/engine/command/define'
require 'flexidb/engine/command/insert'