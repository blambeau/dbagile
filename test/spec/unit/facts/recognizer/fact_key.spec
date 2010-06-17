require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts::Recognizer#normalize_fact" do

  let(:recognizer){ DbAgile::Facts::Recognizer.new }
  
  specify{
    recognizer.fact_key(:supplier, {:'supplier#' => 'S1'}).should == {:'supplier#' => 'S1'}
  }
  specify{
    recognizer.fact_key(:supplier, {:'supplier#' => 'S1', :name => 'Clark'}).should == {:'supplier#' => 'S1'}
  }
  specify{
    recognizer.fact_key(:part, {:'s#' => 'S1', :'p#' => 'P1'}).should == {:'s#' => 'S1', :'p#' => 'P1'}
  }
  
end