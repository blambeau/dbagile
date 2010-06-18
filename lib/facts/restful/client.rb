module Facts
  module Restful
    class Client
      
      # URI of the facts server
      attr_reader :server_uri
      
      # Creates a Client instance that send request
      # to the server located to a given uri
      def initialize(uri)
        require('net/http')
        require('uri')
        require('cgi')
        @server_uri = uri.kind_of?(URI) ? uri : URI::parse(uri.to_s)
      end
      
      # Facts retrieval
      def fact(name, proj)
        query = params.collect{|k,v| '#{k}=#{CGI::escape(v.to_s)}'}.reverse.join('&')
        req = Net::HTTP::Get.new("#{url.path}?#{query}")
        res = Net::HTTP.start(server_uri.host, server_uri.port) {|http|
          http.request(req)
        }
      end
      
    end # class Client
  end # module Restful
end # module Facts