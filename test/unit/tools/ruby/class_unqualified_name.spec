require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::RubyTools#class_unqualified_name /" do
  
  subject{ DbAgile::RubyTools::class_unqualified_name(clazz) }
  
  describe "when called on unqualified class" do
    let(:clazz){ ::String }
    it{ should == "String" }
  end
  
  describe "when called on qualified class" do
    let(:clazz){ DbAgile::RubyTools }
    it{ should == "RubyTools" }
  end
  
end