require File.expand_path('../../../../spec_helper', __FILE__)
require 'flexidb/commands'
describe "::FlexiDB::Commands::Main#looks_an_uri" do
  
  let(:command){ ::FlexiDB::Commands::Main.new }
  
  describe "when called on typical URIs" do
    subject{ command.looks_an_uri?("sqlite://test.db") }
    it{ should be_true }
  end
  
  describe "when called on a file" do
    subject{ command.looks_an_uri?("test.db") }
    it{ should be_false }
  end
  
end