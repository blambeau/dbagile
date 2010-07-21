module DbAgile
  module Doc
    module WLang
      module Rules
      
        # Tag -> method mapping
        DEFAULT_RULESET = {'@' => :at}
      
        # Recognizes Class or Module links
        CLASS_OR_MODULE = /^([A-Z][a-zA-Z]+)(::[A-Z][a-zA-Z]+)*$/
    
        # Creates a html a tag
        def self.a(url, label, blank = false)
          if blank
            "<a href=\"#{url}\" target=\"_blank\">#{label}</a>"
          else
            "<a href=\"#{url}\">#{label}</a>"
          end
        end
    
        # Converts something to a link
        def self.to_link(url, label = nil)
          if url =~ CLASS_OR_MODULE
            a("http://rdoc.info/projects/blambeau/dbagile", label || url)
          else 
            begin
              uri = URI::parse(url)
              if uri.absolute?
                a(url, label || url, true)
              else
                a(url, label || url, false)
              end
            rescue 
              puts "Warning, not a valid link: #{url}"  
            end
          end
        end

        #
        # Implements @{url}{label} tags inside the documentation
        #
        def self.at(parser, offset)
          # Parse the first block (url)
          url, reached = parser.parse(offset, "wlang/active-string")
      
          # Parse the second block if provided
          label = nil
          if parser.has_block?(reached)
            label, reached = parser.parse_block(reached, "wlang/active-string") 
            label = WLang::encode(label, 'wlang/xhtml/entities-encoding')
          end
      
          # Return result
          [to_link(url, label), reached]
        end
      
      end # module Rules
    end # module WLang
  end # module Doc
end # module DbAgile