require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  subject{ tracer.add_columns(:dbagile, :hello => Integer) }
  
  describe "When called without trace options" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.column_names(:dbagile, true).should == [:hello, :id, :schema, :version]
      traced.size.should == 0
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_true
      adapter.column_names(:dbagile, true).should == [:hello, :id, :schema, :version]
      traced[0].should =~ /ALTER TABLE/
    }
  end
  
  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should be_nil
      adapter.column_names(:dbagile, true).should == [:id, :schema, :version]
      traced[0].should =~ /ALTER TABLE/
    }
  end
  
end