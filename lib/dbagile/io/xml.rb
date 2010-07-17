module DbAgile
  module IO
    module XML
      
      DEFAULT_OPTIONS = { :table_element_name  => "table",
                          :row_element_name    => "record"}
      
      # 
      # Outputs some data as a XML string
      #
      # @return [...] the buffer itself
      #
      def to_xml(data, buffer = "", options = {})
        require 'builder'
        options = DEFAULT_OPTIONS.merge(options)
        ten, ren, cen = options[:table_element_name], 
                        options[:row_element_name],
                        options[:column_element_name]
        columns = data.columns
        buffer << '<?xml version="1.0" encoding="UTF-8"?>' << "\n"
        buffer << "<#{ten}>"<< "\n"
        data.each{|row|
          buffer << "  " << "<#{ren}>" << "\n"
          columns.each{|column|
            buffer << "    " << "<#{column}>#{row[column].to_s.to_xs}</#{column}>" << "\n"
          }
          buffer << "  " << "</#{ren}>" << "\n"
        }
        buffer << "</#{ten}>"<< "\n"
        buffer
      end
      module_function :to_xml
      
    end # module YAML
  end # module IO
end # module DbAgile