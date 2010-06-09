require File.expand_path('../../spec_helper', __FILE__)
require 'flexidb/engine'
describe 'FlexiDB::Engine' do
  
  it "should have commands installed as instance methods" do
    FlexiDB::Engine.new.should respond_to(:quit)
  end
  
end
