require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#delete" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  let(:tuple){ {:id => 1, :version => DbAgile::VERSION} }
  before{ adapter.insert(nil, :dbagile, tuple) }
  subject{ tracer.delete(nil, :dbagile, {:id => 1}) }
  
  describe "When called without trace option" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.dataset(:dbagile).to_a.should == []
      traced.should be_empty
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.dataset(:dbagile).to_a.should == []
      traced[0].should =~ /DELETE/
    }
  end
  
  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.dataset(:dbagile).to_a.should == [{:id => 1, :version => DbAgile::VERSION, :schema => nil}]
      traced[0].should =~ /DELETE/
    }
  end
  
end