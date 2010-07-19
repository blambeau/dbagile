require File.expand_path('../../../fixtures', __FILE__)
describe "DbAgile::Core::Chain#plug" do
  
  context "when called on an empty chain" do
    let(:chain){ DbAgile::Core::Chain.new }
    subject{ chain.plug("hello") }
    specify{
      subject.should == chain
      chain.delegate_chain.should == ["hello"]
    }
  end
  
  context "when called on a non empty chain" do
    let(:chain){ DbAgile::Core::Chain.new("hello 1") }
    subject{ chain.plug("hello 2") }
    specify{
      subject.should == chain
      chain.delegate_chain.should == ["hello 2", "hello 1"]
    }
  end

  context "when called with multiple arguments" do
    let(:chain){ DbAgile::Core::Chain.new() }
    subject{ chain.plug("hello 1", "hello 2") }
    specify{
      subject.should == chain
      chain.delegate_chain.should == ["hello 1", "hello 2"]
    }
  end
  
end
