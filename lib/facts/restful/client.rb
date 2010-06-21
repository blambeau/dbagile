module Facts
  module Restful
    class Client
      
      # URI of the facts server
      attr_reader :server_uri
      
      # Creates a Client instance that send request
      # to the server located to a given uri
      def initialize(uri = Restful::server_uri(Restful::DEFAULT_RACK_OPTIONS))
        require('net/http')
        require('uri')
        require('cgi')
        @server_uri = uri.kind_of?(URI) ? uri : URI::parse(uri.to_s)
      end
      
      # Facts retrieval
      def fact(name, proj)
        query = proj.collect{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.reverse.join('&')
        req = Net::HTTP::Get.new("#{server_uri.path}#{name.to_s}/?#{query}")
        res = Net::HTTP.start(server_uri.host, server_uri.port) {|http|
          http.request(req)
        }
        JSON::parse(res.body)
      end
      
      # Facts assertion
      def fact!(name, attributes)
        req = Net::HTTP::Post.new("#{server_uri.path}#{name.to_s}/")
        req.set_form_data(attributes)
        res = Net::HTTP.start(server_uri.host, server_uri.port) {|http|
          http.request(req)
        }
        JSON::parse(res.body)
      end
      
    end # class Client
  end # module Restful
end # module Facts