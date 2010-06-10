require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::Environment#say" do
  
  let(:env){
    DbAgile::Engine::Environment.new.extend(DbAgile::Engine::TestEnvironment)
  }
  before(:each){ env.output_lines = [] }
  
  context "when called with a message" do
    subject{ env.say("hello world") }
    specify{ 
      subject.should be_nil
      env.output_lines.should == ["hello world"] 
    }
  end
  
end