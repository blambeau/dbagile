describe "::DbAgile::Command::API" do
  
  let(:api){ ::DbAgile::Command::API.new(DbAgile::default_environment) }
  
  it "should have instance methods for each command" do
    ::DbAgile::Command::each_subclass do |subclass|
      command_name = DbAgile::Command::ruby_method_for(subclass)
      api.should respond_to(command_name)
    end
  end
  
end