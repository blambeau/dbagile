require File.expand_path('../../../../fixtures', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  subject{ tracer.create_table(nil, :example, :id => Integer) }
  
  describe "When called without trace options" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.has_table?(:example).should be_true
      traced.size.should == 0
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.has_table?(:example).should be_true
      traced[0].should =~ /CREATE TABLE/
    }
  end

  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should be_nil
      adapter.has_table?(:example).should be_false
      traced[0].should =~ /CREATE TABLE/
    }
  end
  
end