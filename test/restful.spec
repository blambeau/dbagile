require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/restful/server'
require 'dbagile/restful/client'
dbagile_load_all_subspecs(__FILE__)

describe "DbAgile::Restful feature" do
  
  let(:environment){ DbAgile::Fixtures::environment                        }
  let(:database_name){ :sqlite                                             }
  let(:database)   { environment.repository.database(database_name)      }
  let(:server)     { DbAgile::Restful::Server.new(environment)             }
  let(:client)     { DbAgile::Restful::Client.new(server.uri)              }
  before(:all)     { server.start                                          }
  after(:all)      { server.stop                                           }
  
  def basic_values_uri(extension = "")
    "#{database_name}/basic_values#{extension}"
  end
      
  describe "the GET interface" do
    it_should_behave_like "The Restful GET interface" 
  end

  describe "the POST interface" do
    it_should_behave_like "The Restful POST interface" 
  end

  describe "the DELETE interface" do
    it_should_behave_like "The Restful DELETE interface" 
  end

end