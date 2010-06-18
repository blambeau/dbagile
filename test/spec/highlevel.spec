require File.expand_path('../spec_helper', __FILE__)
require 'fileutils'

Dir[File.join(File.dirname(__FILE__), "highlevel/**/*.spec")].each{|f| load(f)}

describe "DbAgile" do

  before(:all){
    DbAgile::config(:empty){}
  }
  
  describe("DbAgile - sqlite adapter"){
    let(:sqlite_file){ File.expand_path('../highlevel.db', __FILE__)               }
    let(:conn)       { DbAgile::config(:empty).connect("sqlite://#{sqlite_file}")  }
    before           { FileUtils.rm_rf(sqlite_file)                                }
    after            { FileUtils.rm_rf(sqlite_file)                                }
    it_should_behave_like "All adapters" 
    it_should_behave_like "All transactional adapters" 
  }

  describe("DbAgile - memory adapter"){
    let(:sqlite_file){ File.expand_path('../highlevel.db', __FILE__)               }
    let(:conn)       { DbAgile::config(:empty).connect("memory://test.db")         }
    it_should_behave_like "All adapters" 
  }

end