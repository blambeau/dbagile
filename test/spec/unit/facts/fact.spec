require File.expand_path('../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts#fact" do
  
  let(:uri){ "memory://test.db" }
  let(:factdb){ DbAgile::Facts::connect(uri) }
  let(:s1){ {:'s#' => 'S1', :name => "Clark"} }
  before{
    factdb.fact!(:supplier, s1)
  }
  
  context "when called without default value" do
    specify{
      factdb.fact(:supplier, {:'s#' => 'S1'}).should == s1
      factdb.fact(:supplier, {:'s#' => 'S2'}).should be_nil
    }
  end
  
  context "when called with a default value" do
    specify{
      factdb.fact(:supplier, {:'s#' => 'S1'}, "hello").should == s1
      factdb.fact(:supplier, {:'s#' => 'S2'}, "hello").should == "hello"
    }
  end
  
end