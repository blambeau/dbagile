module DbAgile
  module IO
    module Ruby
      
      # 
      # Outputs some data as a Ruby string
      #
      # @return [...] the buffer itself
      #
      def to_ruby(data, buffer = "", options = {})
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
      
    end # module Ruby
  end # module IO
end # module DbAgile