require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::Environment#ask" do
  
  let(:env){
    DbAgile::Engine::Environment.new.extend(DbAgile::Engine::TestEnvironment)
  }
  before(:each){ env.output_lines = [] }
  
  context "when called with a command without argument" do
    before{ env.input_lines = ["quit"] }
    specify{ 
      env.next_command("prompt> "){|cmd| cmd.should == CodeTree::parse('quit') }
    }
  end
  
  context "when called with a command with one argument" do
    before{ env.input_lines = ["display :table"] }
    specify{ 
      env.next_command("prompt> "){|cmd| cmd.should == CodeTree::parse('display :table') }
    }
  end
  
end