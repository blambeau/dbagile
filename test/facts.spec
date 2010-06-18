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
    let(:server)     { Facts::Restful::Server.new(uri)                             }
    let(:rack_app)   { s = server; Rack::Builder.new{ run s }                      }
    let(:handler)    { Rack::Handler.default                                       }
    specify{ 
      t = Thread.start{ 
        options = {:Port => 9292, :Host => "0.0.0.0", :AccessLog => []}
        handler.run(rack_app, options) 
      }

      # Wait until the server is loaded
      try, ok, res = 0, false, nil
      begin
        res = Net::HTTP.get(URI.parse('http://127.0.0.1:9292/'))
        ok = true
      rescue Errno::ECONNREFUSED => ex
        sleep 0.3
      end until (ok or (try += 1)>10)

      res.should_not be_nil
      t.kill
    }
  }
  
end
