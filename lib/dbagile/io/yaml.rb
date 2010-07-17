module DbAgile
  module IO
    module YAML
      
      # 
      # Outputs some data as a YAML string
      #
      # @return [...] the buffer itself
      #
      def to_yaml(data, buffer = "", options = {})
        require 'yaml'
        ::YAML::dump(data, buffer)
        buffer
      end
      module_function :to_yaml
      
      #
      # Loads some data from a yaml input. If a block is given, yields it with
      # each tuple in turn and returns nil. Otherwise returns an array of tuples.
      #
      def from_yaml(input, options = {})
        require 'yaml'
        data = ::YAML::load(input)
        if block_given?
          if data.respond_to?(:each)
            data.each{|d|
              raise DbAgile::InvalidFormatError, "YAML loaded tuple should be an hash (#{d.inspect})" unless d.kind_of?(Hash)
              yield(d)
            }
          else 
            raise DbAgile::InvalidFormatError, "YAML loaded data should be an array of tuples (#{data.inspect})"
          end
          nil
        else
          data
        end
      end
      module_function :from_yaml
      
    end # module YAML
  end # module IO
end # module DbAgile