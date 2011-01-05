require File.expand_path('../spec_helper', __FILE__)
dbagile_load_all_subspecs(__FILE__)
describe "DbAgile::Command::API /" do
  
  # The environment to use
  let(:dba){ DbAgile::Command::API.new(DbAgile::Fixtures::environment) }
  
  # -- repo
  describe "repo commands /" do 
  
    # Remove empty repo between all test
    before { dba.repository_path = DbAgile::Fixtures::ensure_empty_repository! }
    after  { DbAgile::Fixtures::ensure_empty_repository!                       }
  
    describe "repo:create /" do
      it_should_behave_like "The repo:create command" 
    end
  
  end # -- repo
  
  # -- db
  describe "db commands (touching) /" do 
  
    # Remove empty repo between all test
    before { dba.repository_path = DbAgile::Fixtures::ensure_empty_repository! }
    after  { DbAgile::Fixtures::ensure_empty_repository!                       }
  
    describe "db:add /" do
      it_should_behave_like "The db:add command" 
    end
  
    describe "db:rm /" do
      it_should_behave_like "The db:rm command" 
    end
      
    describe "db:use /" do
      it_should_behave_like "The db:use command" 
    end
  
  end # -- db
  
  # -- db
  describe "repository commands (non touching) /" do 
  
    # Make usage of sqlite for these tests
    before { dba.db_use %{sqlite} }
  
    describe "db:list /" do
      it_should_behave_like "The db:list command" 
    end
  
    describe "db:ping /" do
      it_should_behave_like "The db:ping command" 
    end
  
  end # -- db
  
  # -- bulk
  describe "bulk commands /" do 
  
    # Make usage of sqlite for these tests
    before{ 
      dba.db_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    # describe "bulk:export /" do
    #   it_should_behave_like "The bulk:export command" 
    # end
  
    describe "bulk:import /" do
      it_should_behave_like "The bulk:import command" 
    end
  
  end # -- bulk
  
  # -- sql 
  describe "sql commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.db_use %{sqlite}
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
  
  end # -- sql
  
  # -- schema
  describe "schema commands /" do
    
    # Make usage of sqlite for these tests
    before{ 
      dba.db_use %{sqlite}
      dba.output_buffer = StringIO.new
    }
    
    describe "schema:dump" do
      it_should_behave_like "The schema:dump command" 
    end
  
    describe "schema:check" do
      it_should_behave_like "The schema:check command" 
    end
  
    describe "schema:sql-script" do
      it_should_behave_like "The schema:sql-script command" 
    end
  
    describe "schema:diff" do
      it_should_behave_like "The schema:diff command" 
    end
  
  end # -- schema
  
  # -- dba
  describe "main dba command /" do
  
    it_should_behave_like "The dba command" 
  
  end # -- dba
  
end
