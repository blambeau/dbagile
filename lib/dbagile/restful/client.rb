require 'uri'
require 'cgi'
require 'net/http'
require 'dbagile/restful/client/utils'
require 'dbagile/restful/client/get'
require 'dbagile/restful/client/post'
module DbAgile
  module Restful
    #
    # Helper to query the restful server
    #
    class Client
      include DbAgile::Restful::Client::Utils
      include DbAgile::Restful::Client::Get
      include DbAgile::Restful::Client::Post
      include DbAgile::Tools::Tuple

      # Server uri
      attr_reader :server_uri
      
      #
      # Creates a client instance.
      #
      # @param [String|URI] the uri of the restful server
      #
      def initialize(server_uri)
        @server_uri = case server_uri
          when URI
            server_uri
          when String
            URI.parse(server_uri)
          else
            raise ArgumentError, "Invalid server uri: #{server_uri}"
        end
      end
      
    end # class Client
  end # module Restful
end # module DbAgile