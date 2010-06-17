require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts/recognizer'
describe "::DbAgile::Facts::Recognizer#extract_key" do

  let(:recognizer){ DbAgile::Facts::Recognizer.new(options) }
  
  context "when called on default recognizer" do
    let(:options) { Hash.new }
    let(:supplier){ { :'s#' => 'S1', :sname => "Clark", :city => "London" } }
    let(:part){ { :'p#' => 'P1', :sname => "Nuts" } }
    let(:supplies){ { :'s#' => 'S1', :'p#' => 'P1' } }
    specify{
      recognizer.extract_key(supplier).should == [:'s#']
      recognizer.extract_key(part).should == [:'p#']
      recognizer.extract_key(supplies).should == [:'p#', :'s#']
    }
  end
  
  context "when called on user-defined recognizer" do
    let(:options) { {:key_recognizer => /(^id$|_id$)/} }
    let(:supplier){ { :'s_id' => 'S1', :sname => "Clark", :city => "London" } }
    let(:part){ { :'p_id' => 'P1', :sname => "Nuts" } }
    let(:supplies){ { :'s_id' => 'S1', :'p_id' => 'P1' } }
    specify{
      recognizer.extract_key(supplier).should == [:'s_id']
      recognizer.extract_key(part).should == [:'p_id']
      recognizer.extract_key(supplies).should == [:'p_id', :'s_id']
    }
  end

end
  
