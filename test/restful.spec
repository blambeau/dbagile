require File.expand_path('../spec_helper', __FILE__)
require 'dbagile/restful/server'
require 'dbagile/restful/client'
dbagile_load_all_subspecs(__FILE__)

describe "DbAgile::Restful feature" do
  
  let(:environment){ DbAgile::Fixtures::environment                        }
  let(:config_name){ :sqlite                                               }
  let(:config)     { environment.config_file.config(config_name)           }
  let(:server)     { DbAgile::Restful::Server.new(environment)             }
  let(:client)     { DbAgile::Restful::Client.new(server.uri)              }
  before(:all)     { server.start                                          }
  after(:all)      { server.stop                                           }
  
  def basic_values_uri(extension = "")
    "#{config_name}/basic_values#{extension}"
  end
      
  describe "the GET interface" do
    it_should_behave_like "The Restful GET interface" 
  end

  describe "the POST interface" do
    it_should_behave_like "The Restful POST interface" 
  end

end