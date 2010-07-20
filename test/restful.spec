require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/restful'
require 'dbagile/restful/server'
require 'net/http'
require 'cgi'
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
  def get(table, extension = "", projection = nil)
    url = URI.parse(to_uri(table, extension))
    if projection
      query = "?" + projection.collect{|k,v| "#{CGI::escape(k.to_s)}=#{CGI::escape(v.to_s)}"}.reverse.join('&')
    else
      query = ""
    end
    Net::HTTP.start(url.host, url.port) {|http|
      res = http.get(url.path.to_s + query)
      yield(res, http)
      res.body
    }
  end
      
  # Makes a post request
  # def post(table, extension, tuple)
  #   url = URI.parse(to_uri(table, extension))
  #   Net::HTTP.start(url.host, url.port) {|http|
  #     req = Net::HTTP::Post.new(url.path)
  #     req.set_form_data(tuple)
  #     res = http.request(req)
  #     yield(res, http)
  #     res.body
  #   }
  # end
      
  describe "the GET interface" do
    it_should_behave_like "The Restful GET interface" 
  end

  # describe "the POST interface" do
  #   it_should_behave_like "The Restful POST interface" 
  # end

end