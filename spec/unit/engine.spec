require File.expand_path('../../spec_helper', __FILE__)
require 'dbagile/engine'
describe 'DbAgile::Engine' do
  
  DbAgile::Engine.new(nil).each_command do |cmd|
    context "#{cmd.class} is valid" do
      subject{ lambda{ cmd.class.check } }
      it{ should_not raise_error }
    end
  end
  
  it "should pass connection options to the adapter" do
    tracer = []
    engine = DbAgile::Engine.new(nil, :trace_sql => true, :trace_buffer => tracer) 
    engine.connect("sqlite://test.db")
    engine.database.direct_sql("SELECT 'hello world'")
    tracer.should == ["SELECT 'hello world'\n"]
  end
  
end
