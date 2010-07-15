require File.expand_path('../../spec_helper', __FILE__)
describe "DbAgile::Commands::List command" do
  subject{ DbAgile::Commands::API.list }
  it{ should =~ /ruby_values/ }
end