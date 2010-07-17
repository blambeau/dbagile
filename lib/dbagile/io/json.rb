module DbAgile
  module IO
    module JSON
      
      # 
      # Outputs some data as a JSON string
      #
      # @return [...] the buffer itself
      #
      def to_json(data, buffer = "", options = {})
        require "json"
        if options[:pretty]
          buffer << ::JSON::pretty_generate(data)
        else
          buffer << ::JSON::fast_generate(data)
        end
        buffer
      end
      module_function :to_json
      
      #
      # Loads some data from a json input. If a block is given, yields it with
      # each tuple in turn and returns nil. Otherwise returns an array of tuples.
      #
      def from_json(input, options = {})
        require "json"
        data = ::JSON::load(input)
        if block_given?
          if data.respond_to?(:each)
            data.each{|d|
              raise DbAgile::InvalidFormatError, "JSON loaded tuple should be an hash (#{d.inspect})" unless d.kind_of?(Hash)
              yield(d)
            }
          else 
            raise DbAgile::InvalidFormatError, "JSON loaded data should be an array of tuples (#{data.inspect})"
          end
          nil
        else
          data
        end
      end
      module_function :from_json
      
    end # module JSON
  end # module IO
end # module DbAgile