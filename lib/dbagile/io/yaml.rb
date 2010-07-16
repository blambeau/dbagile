module DbAgile
  module IO
    module YAML
      
      # 
      # Outputs some data as a YAML string
      #
      # @return [...] the buffer itself
      #
      def to_yaml(data, buffer = "", options = {})
        require "yaml"
        ::YAML::dump(data, buffer)
        buffer
      end
      module_function :to_yaml
      
    end # module YAML
  end # module IO
end # module DbAgile