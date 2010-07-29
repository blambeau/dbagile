shared_examples_for("The schema:sql-script command") do
  
  let(:invalid){ File.expand_path('../fixtures/invalid.yaml', __FILE__) }
  let(:announced){ File.expand_path('../fixtures/announced.yaml', __FILE__) }
  let(:effective){ File.expand_path('../fixtures/effective.yaml', __FILE__) }
  let(:add_constraint){ File.expand_path('../fixtures/add_constraint.yaml', __FILE__) }
  
  it "should return the output buffer with CREATE" do
    dba.output_buffer = StringIO.new
    dba.schema_sql_script(%{create}).should == dba.output_buffer
    s = dba.output_buffer.string
    s.should =~ /CREATE/
    s.should_not =~ /DROP/
  end

  it "should return the output buffer with DROP" do
    dba.output_buffer = StringIO.new
    dba.schema_sql_script(%{drop}).should == dba.output_buffer
    s = dba.output_buffer.string
    s.should =~ /DROP/
    s.should_not =~ /CREATE/
  end

  it "should return the output buffer with STAGE (effective vs. announced)" do
    dba.output_buffer = StringIO.new
    dba.schema_sql_script(['stage', effective, announced]).should == dba.output_buffer
    s = dba.output_buffer.string
    s.should =~ /CREATE TABLE .SUPPLIES./
    s.should_not =~ /DROP/
  end

  it "should return the output buffer with STAGE (announced vs. effective)" do
    dba.output_buffer = StringIO.new
    dba.schema_sql_script(['stage', announced, effective]).should == dba.output_buffer
    s = dba.output_buffer.string
    s.should =~ /DROP TABLE .SUPPLIES./
    s.should_not =~ /CREATE/
  end

  it "should support adding foreign keys, if it implies deffered staging" do
    pending("sqlite does not support ALTER TABLE ADD FOREIGN KEY") {
      dba.output_buffer = StringIO.new
      dba.schema_sql_script(['stage', '--no-check', announced, add_constraint]).should == dba.output_buffer
      s = dba.output_buffer.string
      puts s
    }
  end

  it "should raise an error on invalid schema" do
    s = lambda{ dba.schema_sql_script ['create', invalid ] }
    s.should raise_error(DbAgile::SchemaSemanticsError)
  end

  it "should not raise an error on invalid schema with --no-check" do
    s = lambda{ dba.schema_sql_script ['--no-check', 'create', invalid] }
    s.should_not raise_error(DbAgile::SchemaSemanticsError)
  end

end