module DbAgile
  module Doc
    
    # Converts something to a link
    def self.to_link(txt)
      if txt =~ /^([A-Z][a-zA-Z]+)(::[A-Z][a-zA-Z]+)*$/
        url = "http://rdoc.info/projects/blambeau/dbagile"
        "<a href=\"#{url}\" target=\"_blank\">#{txt}</a>"
      else
        puts "Warning, not a valid link: #{txt}"
        txt
      end
    end
     
  end # module Doc
end # module DbAgile
require 'support/doc/browse'