require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Command::command_name_of /" do
  
  subject{ ::DbAgile::Command::command_name_of(command) }
  
  describe "when called on a root command" do
    let(:command){ DbAgile::Command::List }
    it{ should == "list" }
  end
  
  describe "when called on a non root command" do
    let(:command){ DbAgile::Command::Schema::Heading }
    it{ should == "schema:heading" }
  end
  
end