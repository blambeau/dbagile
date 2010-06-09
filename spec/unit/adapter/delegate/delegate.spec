require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Adapter::Delegate" do
  
  describe "methods should correctly be installed" do
    subject{ Object.new.extend(::FlexiDB::Adapter::Delegate) }
    it{ should respond_to(:dataset) }
  end
  
  describe "method should pass parameters correctly" do
    subject{ 
      subject = Object.new.extend(::FlexiDB::Adapter::Delegate) 
      def subject.delegate
        o = Object.new
        def o.dataset(name)
          "Hello #{name}"
        end
        o
      end
      subject
    }
    specify { subject.dataset(:world).should == "Hello world" }
  end
  
end