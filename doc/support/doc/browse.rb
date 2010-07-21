module DbAgile
  module Doc
    # A Rack middleware for browsing documentation while writing it
    class Browse
      
      # Source path
      SOURCE_PATH = File.expand_path('../../../source', __FILE__)
      
      # Path to the template
      TEMPLATE = File.expand_path("#{SOURCE_PATH}/templates/browse.wtpl")
      
      # Converts doc file to html
      def call(env)
        begin 
          path = env['PATH_INFO'].strip[1..-1]
          file = File.join(SOURCE_PATH, 'posts', "#{path}.wtxt")
          if ::File.exists?(file)
            context = {
              :base           => "http://127.0.0.1:9292/",
              :requested_file => file
            }
            wlanged = ::WLang::file_instantiate(TEMPLATE, context)
            [ 200, {'Content-Type' => 'text/html'}, [ wlanged ] ]
          else
            [ 404, {'Content-Type' => 'text/plain'}, [ "No such file #{file}" ] ]
          end
        rescue Exception => ex
          [ 500, {'Content-Type' => 'text/plain'}, [ ex.message, ex.backtrace.join("\n") ] ]
        end
      end
      
    end # class Browse
  end # module Doc 
end # module DbAgile