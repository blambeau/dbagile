require File.expand_path('../../../spec_helper', __FILE__)
describe "::FlexiDB::Plugin#options" do
  
  let(:defplugin){ 
    class DefPlugin < ::FlexiDB::Plugin
      def default_options() {:default => 12} end
    end
    DefPlugin
  }
  
  describe "When initialize with default options without overriding" do
    subject{ defplugin.new(nil, :name => "flexidb").options }
    it { should == {:default => 12, :name => "flexidb"} }
  end

  describe "When initialize with default options with overriding" do
    subject{ defplugin.new(nil, :default => 1, :name => "flexidb").options }
    it { should == {:default => 1, :name => "flexidb"} }
  end

end