module DbAgile
  class Engine
    # 
    # Specialization of Environment to take commands as a ruby DSL.
    #
    # This environment automatically sends a :quit command at the end of
    # the parsing.
    #
    class DslEnvironment < Environment
      
      # DSL used 
      class DSL; 
        attr_accessor :lines
      end
      
      # Creates the environment instance
      def initialize(dsl_block)
        @dsl_block = dsl_block
      end
      
      # Loads lines
      def load_lines
        dsl = DSL.new
        dsl.lines = []
        DbAgile::Engine::COMMANDS.each do |cmd|
          dsl.instance_eval <<-EOF
            def #{cmd.name}(*args)
              self.lines << ["#{cmd.name}", args]
            end
          EOF
        end
        begin
          case @dsl_block
            when Proc
              dsl.instance_eval(&@dsl_block)
            when String
              dsl.instance_eval(@dsl_block)
            else
              raise ArgumentError, "Unable to use #{@dsl_block} as source text"
          end
        rescue NameError => ex
          engine.no_such_command!(ex.name)
        end
        dsl.lines
      end
      
      # Returns the loaded lines
      def lines
        @lines ||= load_lines
      end
      
      # Returns the next command
      def next_command(prompt, &continuation)
        cmd = if (lns = lines).empty?
          ["quit", []]
        else
          lns.shift
        end
        return continuation.call(cmd)
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