require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Command::API" do
  
  let(:api){ ::DbAgile::Command::API.new(DbAgile::default_environment) }
  
  it "should have instance methods for each command" do
    ::DbAgile::Command::each_subclass do |subclass|
      command_name = DbAgile::Command::command_name_of(subclass)
      api.should respond_to(command_name)
    end
  end
  
end