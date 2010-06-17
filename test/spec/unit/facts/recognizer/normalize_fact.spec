require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts::Recognizer#normalize_fact" do

  let(:recognizer){ DbAgile::Facts::Recognizer.new }
  
  context "when called on standard named fact" do
    let(:name){ :supplier }
    let(:tuple){ {:'supplier#' => 'S1', :name => 'Clark'} }
    let(:expected){ [ name,  tuple] }
    
    specify{
      recognizer.normalize_fact(*expected).should == expected
    }
    specify{
      recognizer.normalize_fact(name, tuple).should == expected
    }
    specify{
      recognizer.normalize_fact(tuple).should == expected
    }
    specify{
      recognizer.normalize_fact(:supplier, {:'#' => 'S1', :name => 'Clark'}).should == expected
    }
  end
  
end