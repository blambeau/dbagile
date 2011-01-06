require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema / to_yaml_str" do
  
  let(:left) { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:right){ DbAgile::Fixtures::Core::Schema::schema(:right) }
  
  it "should not print the ---" do
    env = DbAgile::default_environment
    env.message_buffer = StringIO.new
    merged = DbAgile::Core::Schema::merge(left, right){|l,r| nil}
    lambda{ merged.yaml_display(env) }.should_not raise_error
  end
  
end