shared_examples_for("The sql command") do
  
  it "should print the table on the output buffer" do
    dba.sql("SELECT * FROM suppliers")
    dba.output_buffer.string.should =~ /^\+\-/
  end
  
  it "should accept INSERT/DELETE" do
    dba.sql("INSERT INTO basic_values (id, name) VALUES (12, 'Hello World')")
    dba.dataset(:basic_values).count.should == 2
    dba.sql("DELETE FROM basic_values WHERE id=12")
    dba.dataset(:basic_values).count.should == 1
  end
  
  describe "When used with the --file option" do
    
    let(:insert){ File.expand_path("../scripts/insert.sql", __FILE__) }
    let(:delete){ File.expand_path("../scripts/delete.sql", __FILE__) }
    
    it "should execute the file" do
      dba.sql("--file", insert)
      dba.dataset(:basic_values).count.should == 3
      dba.sql("-f", delete)
      dba.dataset(:basic_values).count.should == 1
    end
    
    it "should also execute the query if both are present" do
      dba.sql("--file", insert, "DELETE FROM basic_values WHERE id >= 10")
      dba.dataset(:basic_values).count.should == 1
    end
    
  end
  
end
