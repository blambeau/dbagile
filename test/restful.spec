require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/restful'
require 'dbagile/restful/server'
require 'net/http'
require 'uri'
dbagile_load_all_subspecs(__FILE__)

describe "DbAgile::Restful feature" do
  
  let(:server){ DbAgile::Restful::Server.new(DbAgile::Fixtures::environment) }
  before(:all){ server.start }
  after(:all) { server.stop  }
  
  # Converts a name to an URI
  def to_uri(table, extension)
    "#{server.server_uri}sqlite/#{table}#{extension}"
  end
  
  # Makes a get request
  def get(table, extension)
    url = URI.parse(to_uri(table, extension))
    Net::HTTP.start(url.host, url.port) {|http|
      res = http.get(url.path)
      yield(res, http)
      res.body
    }
  end
      
  describe "the GET interface" do
    it_should_behave_like "The Restful GET interface" 
  end

end