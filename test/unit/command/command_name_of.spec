require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Command::command_name_of /" do
  
  subject{ ::DbAgile::Command::command_name_of(command) }
  
  describe "when called on a root command" do
    let(:command){ DbAgile::Command::Help }
    it{ should == "help" }
  end
  
  describe "when called on a non root command" do
    let(:command){ DbAgile::Command::SQL::Heading }
    it{ should == "sql:heading" }
  end
  
  describe "when called on a complex name command" do
    let(:command){ DbAgile::Command::Schema::CreateScript }
    it{ should == "schema:create-script" }
  end
  
end