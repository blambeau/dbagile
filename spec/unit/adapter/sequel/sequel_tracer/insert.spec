require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  let(:tuple){ {:id => 1, :version => DbAgile::VERSION} }
  subject{ tracer.insert(:dbagile, tuple) }
  
  describe "When called without trace option" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should == tuple
      traced.should be_empty
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should == tuple
      traced[0].should =~ /INSERT INTO/
    }
  end
  
  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should == tuple
      traced[0].should =~ /INSERT INTO/
    }
  end
  
end