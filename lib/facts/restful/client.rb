require 'rest_client'
module Facts
  module Restful
    class Client
      
      # URI of the facts server
      attr_reader :server_uri
      
      # Creates a Client instance that send request
      # to the server located to a given uri
      def initialize(uri = Restful::server_uri(Restful::DEFAULT_RACK_OPTIONS))
        require('uri')
        @server_uri = uri.kind_of?(URI) ? uri : URI::parse(uri.to_s)
      end
      
      # Converts a name to an URI
      def to_uri(name, attributes)
        "#{@server_uri}#{name}/#{attributes[:'#']}"
      end
      
      # Queries fact existence
      def fact?(name, attributes = {})
        RestClient.get(to_uri(name, attributes), :params => attributes)
        true
      rescue RestClient::ResourceNotFound
        false
      end
      
      # Facts retrieval
      def fact(name, attributes)
        res = RestClient.get(to_uri(name, attributes), :params => attributes)
        ::Facts::Restful::json_decode(res.body)
      end
      
      # Facts retrieval, plural form
      def facts(name, attributes = {})
        res = RestClient.get(to_uri(name, {}), :params => attributes)
        ::Facts::Restful::json_decode(res.body)
      end
      
      # Facts assertion
      def fact!(name, attributes)
        res = RestClient.post(to_uri(name, attributes), attributes.to_json, :content_type => :json, :accept => :json)
        ::Facts::Restful::json_decode(res.body)
      end
      
    end # class Client
  end # module Restful
end # module Facts