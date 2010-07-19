require File.expand_path('../fixtures.rb', __FILE__)
describe "The way inheritance works with modules" do
  
  let(:namespace){ DbAgile::Fixtures::Assumptions }
  let(:safe_class){ namespace::UnsafeClass.new.extend(namespace::SafeModule) }
  
  describe "The way modules are included" do
    subject{ safe_class }
    it{ should be_kind_of(namespace::SafeModule) }
  end
  
  describe "The way methods are overriden" do
    subject{ safe_class.safe_method }
    it { should == namespace::UnsafeClass }
  end
  
end