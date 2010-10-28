require "cgi"
module DbAgile
  module IO
    module HTML
      
      DEFAULT_OPTIONS = { }
      
      def with_tag(tag, buffer, indent = 0)
        buffer << "  "*indent << "<#{tag}>\n"
        yield
        buffer << "  "*indent << "</#{tag}>\n"
      end
      module_function :with_tag
      
      # 
      # Outputs some data as an HTML string
      #
      # @return [...] the buffer itself
      #
      def to_html(data, columns = nil, buffer = "", options = {})
        options = DEFAULT_OPTIONS.merge(options)
        with_tag("table", buffer, 0) {
          with_tag("thead", buffer, 1) {
            with_tag("tr", buffer, 2) {
              columns.each{|column|
                buffer << "  "*3 << "<td>#{CGI::escape(column.to_s)}</td>\n"
              }
            }
          }
          with_tag("tbody", buffer, 1) {
            data.each{|row|
              with_tag("tr", buffer, 2) {
                columns.each{|column|
                  value = row[column]
                  cssclazz = value.class.name.to_s.downcase
                  buffer << "  "*3 << "<td class=\"#{cssclazz}\">#{CGI::escape(value.to_s)}</td>\n"
                }
              }
            }
          }
        }
        buffer
      end
      module_function :to_html
      
    end # module HTML
  end # module IO
end # module DbAgile