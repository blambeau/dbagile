require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::Signature#add_argument" do
  
  let(:signature){ DbAgile::Engine::Signature.new }
  
  context("when called with one arguments"){
    subject{ signature.add_argument(:NAME, String) }
    specify{ 
      subject.should_not be_nil
      signature.arguments.size.should == 1
      signature.arguments[0][1].should == [String]
    }
  } 
  
  context("when called with two arguments"){
    subject{ signature.add_argument(:NAME, String, /a-z/) }
    specify{ 
      subject.should_not be_nil
      signature.arguments.size.should == 1
      signature.arguments[0][1].should == [String, /a-z/]
    }
  } 
  
  context("when called with nil arguments"){
    subject{ signature.add_argument(:NAME, nil) }
    specify{ 
      subject.should_not be_nil
      signature.arguments.size.should == 1
      signature.arguments.any?{|arg| arg[1].include?(nil)}.should be_false 
    }
  } 
  
end
