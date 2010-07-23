shared_examples_for("The bulk:import command") do
  
  # --ruby
  
  describe "When used with a --ruby option" do

    it "should work on input buffer by default" do
      File.open(DbAgile::Fixtures::basic_values_path, "r"){|io|
        dba.input_buffer = io
        dba.bulk_import %w{--ruby --drop-table basic_values_copy}
        dba.sql "UPDATE basic_values_copy SET ruby_nil = null"
      }
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end

    it "should accept a --input option" do
      dba.bulk_import ['--input', DbAgile::Fixtures::basic_values_path] + %w{--ruby --drop-table basic_values_copy}
      dba.sql "UPDATE basic_values_copy SET ruby_nil = null"
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end
    
    it "should support an export/import piping through StringIO" do
      dba.bulk_export %w{--ruby basic_values}
      dba.input_buffer  = StringIO.new(dba.output_buffer.string)
      dba.output_buffer = StringIO.new 
      dba.bulk_import %w{--ruby --create-table basic_values_copy}
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end

  end # --ruby
  
  # --format=x --type-safe
  [:csv, :json, :yaml, :ruby].each do |format|
  
    describe "When piping import/export with --type-safe in #{format}" do
  
      it "should be type safe" do
        dba.bulk_export "--format", format, "--type-safe", "basic_values"
        dba.input_buffer  = StringIO.new(dba.output_buffer.string)
        dba.output_buffer = StringIO.new 
        dba.bulk_import "--drop-table", "--format", format, "--type-safe", "basic_values_copy"
        dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
      end
  
    end
    
  end # --format=x --type-safe
  
end