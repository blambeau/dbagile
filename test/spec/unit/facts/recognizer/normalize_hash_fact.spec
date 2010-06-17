require File.expand_path('../../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts::Recognizer#normalize_hash_fact" do

  let(:recognizer){ DbAgile::Facts::Recognizer.new }
  
  context("when called on a valid hash"){
    subject{ recognizer.normalize_hash_fact(:'supplier#' => 'S1') }
    it{ should == [:supplier, {:'supplier#' => 'S1'}] }
  }
  
  [{:'#' => 1}, {:supplier => 1}, {}].each do |hash|
    context("when called on a invalid hash #{hash.inspect}"){
      subject{ lambda{ recognizer.normalize_hash_fact(hash) } }
      it{ should raise_error(DbAgile::Facts::InvalidFactFormatError) }
    }
  end

  
end