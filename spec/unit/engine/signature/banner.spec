require File.expand_path('../../../../spec_helper', __FILE__)
require 'flexidb/engine'
describe "FlexiDB::Engine::Signature#banner" do
  
  let(:signature){ FlexiDB::Engine::Signature.new }
  
  describe "when called without any argument" do
    subject{ signature.banner("command_name") }
    it{ should == "command_name" }
  end
  
  describe "when called without any argument (2)" do
    subject{ signature.banner("command_name2") }
    it{ should == "command_name2" }
  end
  
  describe "when called with one argument" do
    before{ signature.add_argument(:URI, String) }
    subject{ signature.banner("command_name") }
    it{ should == "command_name URI" }
  end
  
  describe "when called with many argument" do
    before{ 
      signature.add_argument(:URI, String) 
      signature.add_argument(:NAME, String) 
      signature.add_argument(:HELP, String) 
    }
    subject{ signature.banner("command_name") }
    it{ should == "command_name URI NAME HELP" }
  end
  
end
