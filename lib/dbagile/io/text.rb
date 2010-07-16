module DbAgile
  module IO
    module Text
      
      # 
      # Outputs some data as a plain text string
      #
      # @return [...] the buffer itself
      #
      def to_text(data, columns, buffer = "", options = {})
        ::DbAgile::IO::PrettyTable::print(data, columns, buffer, options)
        buffer
      end
      module_function :to_text
      
    end # module Text
  end # module IO
end # module DbAgile