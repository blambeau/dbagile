require File.expand_path('../../fixtures', __FILE__)
describe "::DbAgile::Command::command_for /" do
  
  subject{ ::DbAgile::Command::command_for(arg, nil) }
  
  describe "when called with a class" do
    let(:arg){ ::DbAgile::Command::Config::List }
    it{ should be_kind_of(::DbAgile::Command::Config::List) }
  end
  
  describe "when called with a string on a root command" do
    let(:arg){ "help" }
    it{ should be_kind_of(::DbAgile::Command::Help) }
  end
  
  describe "when called with a string on a non root command" do
    let(:arg){ "schema:heading" }
    it{ should be_kind_of(::DbAgile::Command::Schema::Heading) }
  end
  
  describe "when called with a symbol on a root command" do
    let(:arg){ :help }
    it{ should be_kind_of(::DbAgile::Command::Help) }
  end
  
  describe "when called with a symbol on a non root command" do
    let(:arg){ :schema_heading }
    it{ should be_kind_of(::DbAgile::Command::Schema::Heading) }
  end

end