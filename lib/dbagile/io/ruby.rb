module DbAgile
  module IO
    module Ruby
      
      class Reader
        
        def initialize(io, options)
          @io = io
          @options = options
        end

        # Reads content of a file        
        def read(file)
          if @options[:input_file]
            file = File.join(File.dirname(@options[:input_file]), file)
          end
          File.read(file)
        end
        
        def tuples
          self.instance_eval(@io.read)
        end
        
      end
      
      # 
      # Outputs some data as a Ruby string
      #
      # @return [...] the buffer itself
      #
      def to_ruby(data, columns = nil, buffer = "", options = {})
        require 'sbyc/type_system/ruby'
        buffer << "["
        first = true
        data.each{|t| 
          buffer << (first ? "\n  " : ",\n  ")
          buffer << SByC::TypeSystem::Ruby::to_literal(t)
          first = false
        }
        buffer << "\n]"
      end
      module_function :to_ruby
      
      #
      # Interprets io as ruby code that returns an array of tuples 
      # (Hash instance). If a block if given, yields it with each tuple in 
      # turn. Otherwise returns it.
      #
      def from_ruby(io, options = {}, &block)
        tuples = Reader.new(io, options).tuples
        if block
          tuples.each(&block)
          nil
        else
          tuples
        end
      end
      module_function :from_ruby
      
    end # module Ruby
  end # module IO
end # module DbAgile