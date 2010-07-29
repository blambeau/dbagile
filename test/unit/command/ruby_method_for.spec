require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Command::ruby_method_for /" do
  
  subject{ ::DbAgile::Command::ruby_method_for(command) }
  
  describe "when called on a root command" do
    let(:command){ DbAgile::Command::Help }
    it{ should == :help }
  end
  
  describe "when called on a non root command" do
    let(:command){ DbAgile::Command::SQL::Heading }
    it{ should == :sql_heading }
  end
  
  describe "when called on a complex name command" do
    let(:command){ DbAgile::Command::Schema::SqlScript }
    it{ should == :schema_sql_script }
  end
  
end