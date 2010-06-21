require 'rubygems'
gem "rack", ">= 1.1.0"
require 'rack'
require 'uri'
require 'cgi'

module Facts
  module Restful
    
    # Default Rack options for restful server and client
    DEFAULT_RACK_OPTIONS = {:Port => 8711, :Host => "127.0.0.1", :AccessLog => []}
    
    # Returns the server uri given by options
    def server_uri(options)
      URI::parse("http://#{options[:Host]}:#{options[:Port]}/")
    end
    module_function :server_uri
    
  end # module Restful
end # module Facts
require 'facts/restful/client'
require 'facts/restful/server'
