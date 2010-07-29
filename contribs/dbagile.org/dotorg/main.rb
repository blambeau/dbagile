require 'rubygems'
gem 'wlang', ">= 0.9.2"
require 'wlang'
require 'wlang/dialects/xhtml_dialect'
require 'wlang/dialects/coderay_dialect'

require 'dbagile'
require 'dotorg/utils'
require 'dotorg/schema_converter'
module DbAgile
  module DotOrg
    class Main
      include DotOrg::Utils
      
      # Creates a middleware instance
      def initialize
        @delegate = ::Rack::File.new(PUBLIC_PATH)
      end
      
      # Converts doc file to html
      def call(env)
        begin 
          path = env['PATH_INFO'].strip[1..-1]
          if path.empty?
            env['PATH_INFO'] = '/convert'
            call(env)
          elsif File.exists?(File.join(PUBLIC_PATH, path))
            @delegate.call(env)
          else 
            wlang_on_page(env, path)
          end
        rescue Exception => ex
          _500_(env, ex.message)
        end
      end
      
    end # class Main
  end # modul DotOrg
end # module DbAgile
