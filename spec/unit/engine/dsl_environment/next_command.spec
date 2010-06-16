require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::DslEnvironment#load_lines" do
  
  let(:source) {
    lambda{
      plug AgileTable
    }
  }
  let(:env){ DbAgile::Engine::DslEnvironment.new(source) }
  
  specify{
    env.next_command("hello"){|cmd| cmd.should == CodeTree::parse{ (plug AgileTable) } }
    env.next_command("hello"){|cmd| cmd.should == [:quit, []]}
  }
  
end