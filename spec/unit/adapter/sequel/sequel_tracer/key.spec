require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  let(:tuple){ {:version => DbAgile::VERSION} }
  before{ adapter.insert(:dbagile, tuple) }
  subject{ tracer.key(:dbagile, [:version]) }
  
  describe "When called without trace options" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      lambda{ adapter.insert(:dbagile, tuple) }.should raise_error
      traced.size.should == 0
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      lambda{ adapter.insert(:dbagile, tuple) }.should raise_error
      traced[0].should =~ /INDEX/
    }
  end

  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should be_nil
      lambda{ adapter.insert(:dbagile, tuple) }.should_not raise_error
      traced[0].should =~ /INDEX/
    }
  end
  
end