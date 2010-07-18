module DbAgile
  module IO
    module YAML
      extend IO::TypeSafe
      
      # 
      # Outputs some data as a YAML string
      #
      # @return [...] the buffer itself
      #
      def to_yaml(data, buffer = "", options = {})
        require 'yaml'
        ::YAML::dump(to_typesafe_relation(options[:type_system], data), buffer)
        buffer
      end
      module_function :to_yaml
      
      #
      # Loads some data from a yaml input. If a block is given, yields it with
      # each tuple in turn and returns nil. Otherwise returns an array of tuples.
      #
      def from_yaml(input, options = {}, &block)
        require 'yaml'
        from_typesafe_xxx(::YAML::load(input), options, &block)
      end
      module_function :from_yaml
      
    end # module YAML
  end # module IO
end # module DbAgile