shared_examples_for("The schema:diff command") do
  
  let(:invalid){ File.expand_path('../fixtures/invalid.yaml', __FILE__) }
  let(:announced){ File.expand_path('../fixtures/announced.yaml', __FILE__) }
  let(:effective){ File.expand_path('../fixtures/effective.yaml', __FILE__) }
  
  it "should return merged schema" do
    dba.output_buffer = StringIO.new
    dba.schema_diff([announced, effective]).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
  end
  
  it "should show all differences without -u" do
    dba.output_buffer = StringIO.new
    dba.schema_diff([effective, announced]).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    s = dba.output_buffer.string
    s.should =~ /PARTS/
    s.should =~ /SUPPLIERS/
    s.should =~ /SUPPLIES/
  end
  
  it "should not show all differences with -u" do
    dba.output_buffer = StringIO.new
    dba.schema_diff(['-u', effective, announced]).should be_kind_of(DbAgile::Core::Schema::DatabaseSchema)
    s = dba.output_buffer.string
    s.should =~ /PARTS/
    s.should_not =~ /SUPPLIERS/
    s.should_not =~ /SUPPLIES/
  end

end