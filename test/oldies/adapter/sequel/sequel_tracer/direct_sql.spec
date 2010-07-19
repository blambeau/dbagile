require File.expand_path('../../../../fixtures', __FILE__)
describe "::DbAgile::SequelAdapter::SequelTracer#direct_sql" do
  
  let(:adapter){ Fixtures::sqlite_testdb_sequel_adapter }
  let(:tracer) { DbAgile::SequelAdapter::SequelTracer.new(adapter, options) }
  let(:traced){ [] }
  subject{ tracer.direct_sql(nil, "SELECT * FROM dbagile") }
  
  describe "When called without trace option" do
    let(:options){ {:trace_sql => false, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_kind_of(Enumerable) 
      traced.should be_empty
    }
  end
  
  describe "When called with trace and delegate options" do
    let(:options){ {:trace_sql => true, :trace_only => false, :trace_buffer => traced} }
    specify{ 
      subject.should be_kind_of(Enumerable) 
      traced.should == ["SELECT * FROM dbagile\n"]
    }
  end

  describe "When called with trace and trace_only options" do
    let(:options){ {:trace_sql => true, :trace_only => true, :trace_buffer => traced} }
    specify{ 
      subject.should be_nil
      traced.should == ["SELECT * FROM dbagile\n"]
    }
  end
  
end