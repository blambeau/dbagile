module DbAgile
  module DotOrg
    module Utils
      
      # Root path
      ROOT_PATH = File.expand_path('../../', __FILE__)
      
      # Public path
      PUBLIC_PATH = File.join(ROOT_PATH, 'public')
      
      # Path to the template
      PAGES = File.join(ROOT_PATH, "pages")
      
      # Path to the template
      MAIN_TEMPLATE = File.join(ROOT_PATH, "templates/main.wtpl")
      
      # Returns a 404 response
      def _404_(env, ex = nil)
        [
          404, 
          {'Content-Type' => 'text/plain'},
          [ "Not found #{env['PATH_INFO']}: " ] + (ex.nil? ? [] : [ ex.message ])
        ]
      end
    
      # Returns a 200 response for a given format
      def _200_(env, type, result)
        [
          200,
          {'Content-Type' => type},
          result
        ]
      end
    
      # Returns a 200 response for a given format
      def _302_(env, location)
        [
          302,
          {'Content-Type' => 'text/plain', 
           'Location' => location},
          [ location ]
        ]
      end
      
      # Returns a 500 response
      def _500_(env, message)
        [
          500, 
          {'Content-Type' => 'text/plain'}, 
          [ message ]
        ]
      end
      
      # Returns wlang on a main page
      def wlang_on_page(env, page, template = MAIN_TEMPLATE, context = {})
        file = File.join(PAGES, "#{page}.wtpl")
        if File.exists?(file)
          context = context.merge({
            :base           => "http://127.0.0.1:9292/",
            :requested_file => file
          })
          wlanged = ::WLang::file_instantiate(template, context)
          _200_(env, 'text/html', [ wlanged ])
        else
          _404_(env)
        end
      end
      
    end # module Utils
  end # module DotOrg
end # module DbAgile 
