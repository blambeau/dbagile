require 'rubygems'
gem "rack", ">= 1.1.0"
require 'rack'
require 'uri'
require 'cgi'
require 'json'

module Facts
  module Restful
    
    # Default Rack options for restful server and client
    DEFAULT_RACK_OPTIONS = {:Port => 8711, :Host => "127.0.0.1", :AccessLog => []}
    
    # Returns the server uri given by options
    def server_uri(options)
      URI::parse("http://#{options[:Host]}:#{options[:Port]}/")
    end
    module_function :server_uri
    
    # Methodizes keys of a hash
    def hash_methodize(hash)
      m = {}
      hash.each_pair{|k,v| m[k.to_s.to_sym] = v}
      m
    end
    module_function :hash_methodize
    
    # Encodes a fact using JSON
    def json_encode(fact)
      ::JSON.generate(fact)
    end
    module_function :json_encode
    
    # Decodes a fact using JSON
    def json_decode(fact)
      hash_methodize(JSON::parse(fact))
    end
    module_function :json_decode
    
  end # module Restful
end # module Facts
require 'facts/restful/client'
require 'facts/restful/server'
