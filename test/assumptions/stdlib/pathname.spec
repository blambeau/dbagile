require File.expand_path('../../fixtures.rb', __FILE__)
require 'pathname'
describe "Pathname utility" do
  
  it "should be able to relativize files" do
    child = Pathname.new(__FILE__)
    parent = Pathname.new(File.dirname(File.dirname(__FILE__)))
    rel = child.relative_path_from(parent)
    rel.should be_relative
    rel.to_s.should == "stdlib/pathname.spec"
  end
  
end