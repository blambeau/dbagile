$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../fixtures', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../support', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'facts'
require 'spec'
require 'spec/autorun'
require 'net/http'
require 'uri'
require 'rest_client'
Dir["#{File.dirname(__FILE__)}/facts/**/*.spec"].each{|f| Kernel::load(f)}

describe "Facts" do
  
  describe("Facts - on sqlite"){
    let(:sqlite_file){ File.expand_path('../facts.db', __FILE__)                   }
    let(:db)         { Facts::connect("sqlite://#{sqlite_file}")                   }
    before           { FileUtils.rm_rf(sqlite_file)                                }
    after            { FileUtils.rm_rf(sqlite_file)                                }
    it_should_behave_like "Facts - Basics" 
  }
  
  describe("Facts - restful interface"){
    let(:sqlite_file){ File.expand_path('../facts.db', __FILE__)                   }
    let(:uri)        { "sqlite://#{sqlite_file}"                                   }
    let(:server)     { Facts::Restful::Server.new(uri)                             }
    let(:resturi)    { "http://127.0.0.1:8711"                                     }
    before           { FileUtils.rm_rf(sqlite_file); server.start                  }
    after            { server.stop; FileUtils.rm_rf(sqlite_file)                   }
    it_should_behave_like "Restful interface" 
  }
  
end
