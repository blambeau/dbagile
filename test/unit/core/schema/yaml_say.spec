require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema / to_yaml_str" do
  
  let(:left) { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:right){ DbAgile::Fixtures::Core::Schema::schema(:right) }
  
  it "should not print the ---" do
    env = DbAgile::default_environment
    env.output_buffer = StringIO.new
    lambda{ (left + right).yaml_say(env) }.should_not raise_error
  end
  
end