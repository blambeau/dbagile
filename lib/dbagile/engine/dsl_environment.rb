require 'rubygems'
require 'sbyc'
module DbAgile
  class Engine
    # 
    # Specialization of Environment to take commands as a ruby DSL.
    #
    # This environment automatically sends a :quit command at the end of
    # the parsing.
    #
    class DslEnvironment < Environment
      
      # Creates the environment instance
      def initialize(dsl_block)
        @dsl_block = dsl_block
      end
      
      # Loads lines
      def load_lines
        ::CodeTree::parse(@dsl_block,:multiline => true)
      end
      
      # Returns the loaded lines
      def lines
        @lines ||= load_lines
      end
      
      # Returns the next command
      def next_command(prompt, &continuation)
        cmd = if (lns = lines).empty?
          [:quit, []]
        else
          compile(lns.shift)
        end
        return continuation.call(cmd)
      end
      
      # Compiles a CodeTree::AstNode expression
      def compile(astnode)
        cmd_name = astnode.function
        cmd_args = astnode.children.collect{|c| c.literal}
        [cmd_name, cmd_args]
      end
      
      # This one is silent
      def on_error(error)
        error
      end
      
      # This one is silent on say
      def say(something, color = nil)
      end
      
    end # class DslEnvironment
  end # class Engine
end # module DbAgile