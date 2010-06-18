$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../fixtures', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../support', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'rubygems'
require 'facts'
require 'spec'
require 'spec/autorun'
Dir["#{File.dirname(__FILE__)}/facts/**/*.spec"].each{|f| Kernel::load(f)}

describe "Facts" do
  
  describe("Facts - on sqlite"){
    let(:sqlite_file){ File.expand_path('../facts.db', __FILE__)                   }
    let(:db)         { Facts::connect("sqlite://#{sqlite_file}")                   }
    before           { FileUtils.rm_rf(sqlite_file)                                }
    after            { FileUtils.rm_rf(sqlite_file)                                }
    it_should_behave_like "Facts - Basics" 
  }
  
end
