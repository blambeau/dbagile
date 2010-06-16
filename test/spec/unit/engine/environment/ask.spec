require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Engine::Environment#ask" do
  
  let(:env){
    DbAgile::Engine::Environment.new.extend(DbAgile::Engine::TestEnvironment)
  }
  before(:each){ env.output_lines = [] }
  
  context "when called with a simple prompt" do
    before{ env.input_lines = ["hello world"] }
    specify{ 
      env.ask("prompt> "){|something| something.should == "hello world" }
    }
  end
  
  context "when called multiple times" do
    before{ env.input_lines = ["hello0", "hello1"] }
    specify{ 
      2.times do |i|
        env.ask("prompt> "){|something| 
          something.should == "hello#{i}" 
        }
      end
    }
  end
  
end