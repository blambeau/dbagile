require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Plugin#options" do
  
  let(:defplugin){ 
    class DefPlugin < ::DbAgile::Plugin
      def default_options() {:default => 12} end
    end
    DefPlugin
  }
  
  describe "When initialize with default options without overriding" do
    subject{ defplugin.new(:name => "dbagile").options }
    it { should == {:default => 12, :name => "dbagile"} }
  end

  describe "When initialize with default options with overriding" do
    subject{ defplugin.new(:default => 1, :name => "dbagile").options }
    it { should == {:default => 1, :name => "dbagile"} }
  end

end