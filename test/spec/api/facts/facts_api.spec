require File.expand_path('../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "DbAgile::Facts API" do
  
  let(:factdb){ DbAgile::Facts::connect("memory://test.db") }
  
  it "should basically support fact!, fact? and fact" do
    factdb.transaction do |t|
      # Insert a fact
      fact = t.fact!(:supplier, {:'#' => 'S1', :name => 'Smith', :status => 20, :city => 'London'})
      fact.should == {:'supplier#' => 'S1'}

      # Query it
      t.fact?(fact).should == true
      t.fact?(:supplier, {:'#' => 'S1'}).should == true
      t.fact?(:supplier, {:'#' => 'S2'}).should == false
      
      # Get it 
      t.fact(fact).should == {:'supplier#' => 'S1', :name => 'Smith', :status => 20, :city => 'London'}
      t.fact(:supplier, {:'#' => 'S1'}).should == {:'supplier#' => 'S1', :name => 'Smith', :status => 20, :city => 'London'}
      t.fact(:supplier, {:'#' => 'S2'}).should be_nil
    end
  end
  
end