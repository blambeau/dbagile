require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts/recognizer'
describe "::DbAgile::Facts::Recognizer#is_key_part" do
  
  let(:recognizer){ DbAgile::Facts::Recognizer.new(options) }
  
  context "when called on default recognizer" do
    let(:options) { Hash.new }
    specify{
      recognizer.is_key_part?(:'supplier#').should be_true
      recognizer.is_key_part?(:'name').should be_false
    }
  end
  
  context "when called on user-defined recognizer" do
    let(:options) { {:key_recognizer => /(^id$|_id$)/} }
    specify{
      recognizer.is_key_part?(:'id').should be_true
      recognizer.is_key_part?(:'supplier_id').should be_true
      recognizer.is_key_part?(:'pid').should be_false
      recognizer.is_key_part?(:'idea').should be_false
    }
  end
  
end
