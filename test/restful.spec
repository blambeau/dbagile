require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/restful/server'
require 'dbagile/restful/client'
dbagile_load_all_subspecs(__FILE__)

describe "DbAgile::Restful feature" do
  
  let(:server){ DbAgile::Restful::Server.new(DbAgile::Fixtures::environment) }
  let(:client){ DbAgile::Restful::Client.new(server.uri)                     }
  before(:all){ server.start }
  after(:all) { server.stop  }
  
  def basic_values_uri(extension = "")
    "sqlite/basic_values#{extension}"
  end
      
  describe "the GET interface" do
    it_should_behave_like "The Restful GET interface" 
  end

  describe "the POST interface" do
    it_should_behave_like "The Restful POST interface" 
  end

end