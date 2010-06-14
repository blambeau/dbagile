require File.expand_path('../../spec_helper', __FILE__)
require 'dbagile/engine'
describe 'DbAgile::Engine' do
  
  it "should pass connection options to the adapter" do
    tracer = []
    engine = DbAgile::Engine.new(nil, :trace_sql => true, :trace_buffer => tracer) 
    engine.connect("sqlite://test.db")
    engine.database.direct_sql("SELECT 'hello world'")
    tracer.should == ["SELECT 'hello world'\n"]
  end
  
end
