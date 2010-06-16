require File.expand_path('../../../spec_helper', __FILE__)
describe "::DbAgile::Adapter.factor" do
  
  let(:options){ Hash.new }
  subject{ ::DbAgile::Adapter.factor(uri, options) }
  
  describe "when called with memory scheme" do
    let(:uri){ "memory://test.db" }
    it{ should be_kind_of(::DbAgile::MemoryAdapter) }
  end
  
  describe "when called with sqlite scheme" do
    let(:uri){ "sqlite://test.db" }
    it{ should be_kind_of(::DbAgile::SequelAdapter) }
  end
  
  
end
