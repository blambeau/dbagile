module DbAgile
  module IO
    module JSON
      extend IO::TypeSafe
      
      # 
      # Outputs some data as a JSON string
      #
      # @return [...] the buffer itself
      #
      def to_json(data, columns = nil, buffer = "", options = {})
        require "json"
        pretty, first = options[:pretty], true
        buffer << (pretty ? "[\n" : "[")
        with_type_safe_relation(data, options) do |tuple|
          buffer << (pretty ? ",\n" : ",") unless first
          if pretty
            buffer << ::JSON::pretty_generate(tuple)
          else
            buffer << ::JSON::fast_generate(tuple)
          end
        end
        buffer << (pretty ? "\n]" : "]")
        buffer
      end
      module_function :to_json
      
      #
      # Loads some data from a json input. If a block is given, yields it with
      # each tuple in turn and returns nil. Otherwise returns an array of tuples.
      #
      def from_json(input, options = {}, &block)
        require "json"
        from_typesafe_xxx(::JSON::load(input), options, &block)
      end
      module_function :from_json
      
    end # module JSON
  end # module IO
end # module DbAgile