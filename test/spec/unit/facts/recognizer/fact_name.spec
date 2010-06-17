require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts/recognizer'
describe "::DbAgile::Facts::Recognizer#fact_name" do

  let(:recognizer){ DbAgile::Facts::Recognizer.new(options) }
  
  context "when called on default recognizer" do
    let(:options) { Hash.new }
    let(:supplier){ { :'s#' => 'S1', :sname => "Clark", :city => "London" } }
    let(:part){ { :'p#' => 'P1', :sname => "Nuts" } }
    let(:supplies){ { :'s#' => 'S1', :'p#' => 'P1' } }
    specify{
      recognizer.fact_name(supplier).should == :'s#'
      recognizer.fact_name(part).should == :'p#'
      recognizer.fact_name(supplies).should == :'p#s#'
    }
  end
  
end
  
