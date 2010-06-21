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
      
      # Queries fact existence
      def fact?(name, attributes)
        case res = do_get(name, attributes)
          when Net::HTTPSuccess
            true
          when Net::HTTPNotFound
            false
          else
            raise "Unexpected result #{res.inspect}"
        end
      end
      
      # Facts retrieval
      def fact(name, attributes)
        case res = do_get(name, attributes)
          when Net::HTTPSuccess
            Restful::json_decode(res.body)
          when Net::HTTPNotFound
            {}
          else
            raise "Unexpected result #{res.inspect}"
        end
      end
      
      # Facts assertion
      def fact!(name, attributes)
        case res = do_post(name, attributes)
          when Net::HTTPSuccess
            Restful::json_decode(res.body)
          when Net::HTTPNotFound
            {}
          else
            raise "Unexpected result #{res.inspect}"
        end
      end
      
      ### Private section ##########################################################
      
      private
      
      # Makes a get request to the server and returns the HTTP result
      def do_get(fact, attributes)
        Net::HTTP.start(server_uri.host, server_uri.port) {|http|
          req = Net::HTTP::Get.new(fact_path_and_query(fact, attributes))
          http.request(req)
        }
      end
      
      # Makes a post request to the server and returns the HTTP result
      def do_post(fact, attributes)
        Net::HTTP.start(server_uri.host, server_uri.port) {|http|
          req = Net::HTTP::Post.new(fact_path_and_query(fact))
          req.set_form_data(attributes)
          http.request(req)
        }
      end
      
      # Converts a hash to an url query
      def hash_to_urlquery(h)
        h.collect{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.reverse.join('&')
      end
      
      # Returns a fact URI
      def fact_path_and_query(fact, params = nil)
        uri = "#{server_uri.path}#{fact}"
        uri += "?#{hash_to_urlquery(params)}" unless params.nil?
        uri
      end
      
    end # class Client
  end # module Restful
end # module Facts