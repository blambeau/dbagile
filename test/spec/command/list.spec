require File.expand_path('../../spec_helper', __FILE__)
describe "DbAgile::Commands::List command" do
  let(:command){ DbAgile::Commands::List.new }
  let(:options){ [] }
  specify{
    command.buffer = ""
    lambda{ command.run(__FILE__, options) }.should_not raise_error
    command.buffer.should =~ /values_sqlite/
  }
end