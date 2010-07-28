require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile::Command::API /" do
  
  # Path to an empty repository file
  let(:empty_repository_path){ File.expand_path('../fixtures/configs/empty_config.dba', __FILE__) }
  
  # The environment to use
  let(:dba){ DbAgile::Command::API.new(DbAgile::Fixtures::environment) }
  
  # Clean everything after tests
  after(:all) { FileUtils.rm_rf(empty_repository_path) }
    
  # -- Configuration
  describe "repository commands (touching) /" do 
  
    # Remove empty repo between all test
    before       {  dba.repository_path = empty_repository_path }
    before(:each){ FileUtils.rm_rf(empty_repository_path)        }
  
    describe "repo:add /" do
      it_should_behave_like "The repo:add command" 
    end
  
    describe "repo:rm /" do
      it_should_behave_like "The repo:rm command" 
    end
  
    describe "repo:use /" do
      it_should_behave_like "The repo:use command" 
    end
  
  end # -- Configuration
  
  # -- Configuration
  describe "repository commands (non touching) /" do 
  
    # Make usage of sqlite for these tests
    before { dba.repo_use %{sqlite} }
  
    describe "repo:list /" do
      it_should_behave_like "The repo:list command" 
    end
  
    describe "repo:ping /" do
      it_should_behave_like "The repo:ping command" 
    end
  
  end # -- Configuration
  
  # -- Input/Output
  describe "bulk commands /" do 
  
    # Make usage of sqlite for these tests
    before{ 
      dba.repo_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "bulk:export /" do
      it_should_behave_like "The bulk:export command" 
    end
  
    describe "bulk:import /" do
      it_should_behave_like "The bulk:import command" 
    end
  
  end # -- Input/Output
  
  # -- Sql 
  describe "sql commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.repo_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "sql:send /" do
      it_should_behave_like "The sql:send command" 
    end
  
    describe "sql:show /" do
      it_should_behave_like "The sql:show command" 
    end
  
    describe "sql:heading /" do
      it_should_behave_like "The sql:heading command" 
    end
  
    describe "sql:drop /" do
      it_should_behave_like "The sql:drop command" 
    end

  end # -- Query
  
  # -- Schema
  describe "schema commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.repo_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "schema:dump" do
      it_should_behave_like "The schema:dump command" 
    end

    describe "schema:check" do
      it_should_behave_like "The schema:check command" 
    end

  end # -- Schema
  
end
