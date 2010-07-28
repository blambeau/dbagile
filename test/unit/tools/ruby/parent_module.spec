require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::RubyTools#parent_module /" do
  
  subject{ DbAgile::RubyTools::parent_module(clazz) }
  
  describe "when called on unqualified class" do
    let(:clazz){ ::String }
    it{ should be_nil }
  end
  
  describe "when called on qualified class" do
    let(:clazz){ DbAgile::RubyTools }
    it{ should == DbAgile }
  end
  
  describe "when called on long qualified class" do
    let(:clazz){ DbAgile::Fixtures::Utils }
    it{ should == DbAgile::Fixtures }
  end
  
end