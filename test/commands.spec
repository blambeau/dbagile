require File.expand_path('../spec_helper', __FILE__)
Dir[File.expand_path('../commands/**/*.spec', __FILE__)].each{|f| load(f)}
describe "DbAgile::Command through API" do
  
  # Path to an empty configuration file
  let(:empty_config_path){ File.expand_path('../fixtures/configs/empty_config.dba', __FILE__) }
  
  # The environment to use
  let(:environment){ DbAgile::Fixtures::environment }
  let(:env){ DbAgile::Fixtures::environment }
  let(:dba){ DbAgile::Command::API.new(env) }
  
  # Remove empty config between all test
  before(:each){ FileUtils.rm_rf(empty_config_path) }
  after(:each){ FileUtils.rm_rf(empty_config_path) }
  
  ### Configuration commands
  
  describe "The configuration commands" do 
    describe "The list command" do
      it_should_behave_like "The list command" 
    end

    describe "The add command" do
      it_should_behave_like "The add command" 
    end
  
    describe "The rm command" do
      it_should_behave_like "The rm command" 
    end
  
    describe "The use command" do
      it_should_behave_like "The use command" 
    end
  
    describe "The ping command" do
      it_should_behave_like "The ping command" 
    end
  end
  
  ### Inport/Export commands
  describe "The input/output commands" do 

    before{ 
      dba.use(%w{sqlite}) 
      env.output_buffer = StringIO.new
    }
      
    describe "The show command" do
      it_should_behave_like "The show command" 
    end
  
    describe "The export command" do
      it_should_behave_like "The export command" 
    end
  end
  
end
