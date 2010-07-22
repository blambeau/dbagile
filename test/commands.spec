require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile::Command::API /" do
  
  # Path to an empty configuration file
  let(:empty_config_path){ File.expand_path('../fixtures/configs/empty_config.dba', __FILE__) }
  
  # The environment to use
  let(:dba){ DbAgile::Command::API.new(DbAgile::Fixtures::environment) }
  
  # Clean everything after tests
  after(:all) { FileUtils.rm_rf(empty_config_path) }
    
  # -- Configuration
  describe "configuration commands (touching) /" do 
  
    # Remove empty config between all test
    before       {  dba.config_file_path = empty_config_path }
    before(:each){ FileUtils.rm_rf(empty_config_path)        }
  
    describe "add" do
      it_should_behave_like "The add command" 
    end
  
    describe "rm" do
      it_should_behave_like "The rm command" 
    end
  
    describe "use" do
      it_should_behave_like "The use command" 
    end
  
  end # -- Configuration
  
  # -- Configuration
  describe "configuration commands (touching) /" do 
  
    # Make usage of sqlite for these tests
    before { dba.use %{sqlite} }
  
    describe "list" do
      it_should_behave_like "The list command" 
    end
  
    describe "ping" do
      it_should_behave_like "The ping command" 
    end

  end # -- Configuration
  
  # -- Input/Output
  describe "input/output commands" do 

    # Make usage of sqlite for these tests
    before{ 
      dba.use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "The show command" do
      it_should_behave_like "The show command" 
    end

    describe "The export command" do
      it_should_behave_like "The export command" 
    end

    describe "The import command" do
      it_should_behave_like "The import command" 
    end

  end # -- Input/Output
  
  # -- Query
  describe "query commands" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "The sql command" do
      it_should_behave_like "The sql command" 
    end

  end # -- Query
  
  # -- Schema
  describe "schema commands" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "The heading command" do
      it_should_behave_like "The heading command" 
    end

    describe "The drop command" do
      it_should_behave_like "The drop command" 
    end

    describe "The schema:dump command" do
      it_should_behave_like "The schema:dump command" 
    end

  end # -- Schema
  
end
