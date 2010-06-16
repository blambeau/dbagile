require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::Engine's API" do
  
  it "should support not connecting at all" do
    engine = DbAgile::Engine.new
    engine.execute("(assert true)")
  end
  
  it "should support creating, connecting and executing a source" do
    engine = DbAgile::Engine.new
    engine.connect("memory://test.db").should be_kind_of(::DbAgile::Core::Connection)
    engine.execute("(assert true)")
    engine.disconnect
  end
  
  it "should support connecting on the fly" do
    engine = DbAgile::Engine.new
    engine.execute("(connect 'memory://test.db')")
    engine.disconnect
  end
  
  it "should support starting a transaction and stopping after that" do
    engine = DbAgile::Engine.new
    engine.execute("(connect 'memory://test.db'); start_transaction; commit")
    engine.disconnect
  end
  
end
  
