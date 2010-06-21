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
    specify{ 
      server = ::Facts::Restful::Server.start(uri)
      client = ::Facts::Restful::Client.new
      client.fact!(:tools, {:'#' => 1, :name => "facts", :version => Facts::VERSION}).should be_kind_of(Hash)
      client.fact(:tools, {:'#' => 1}).should be_kind_of(Hash)
      server.kill
    }
  }
  
end
