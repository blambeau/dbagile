require File.expand_path('../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter.new" do
  
  context "when called without options at all" do
    subject{ DbAgile::SequelAdapter.new("sqlite://test.db") }
    it{ should be_kind_of(DbAgile::SequelAdapter) }
  end 
  
  context "when called without options but no tracing" do
    subject{ DbAgile::SequelAdapter.new("sqlite://test.db", :trace_sql => false) }
    it{ should be_kind_of(DbAgile::SequelAdapter) }
  end 
  
  context "when called without options but no tracing" do
    subject{ DbAgile::SequelAdapter.new("sqlite://test.db", :trace_sql => true) }
    it{ should be_kind_of(DbAgile::SequelAdapter::SequelTracer) }
  end 
  
end