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
      
    end # module JSON
  end # module IO
end # module DbAgile