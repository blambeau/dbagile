module FlexiDB
  class Engine
    class Command
    
      # Returns the command name
      def self.command_name
        self.name =~ /([A-Za-z]+)$/
        $1.downcase.to_sym
      end
    
      # Returns command's banner
      def banner
        self.class.command_name.to_s
      end  
    
      # Returns command's help
      def help
        "Sorry, no documentation for #{self.banner}"
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
