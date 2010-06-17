require File.expand_path('../../../../spec_helper', __FILE__)
describe "DbAgile::Core::Transaction" do
  
  subject{ ::DbAgile::Core::Transaction.new(nil) }
  it{ should respond_to(:ping) }
  it{ should respond_to(:dataset) }
  it{ should respond_to(:create_table) }
  
end
  
