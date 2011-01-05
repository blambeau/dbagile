shared_examples_for("The bulk:import command") do
  
  # --ruby
  
  describe "When used with a --ruby option" do
  
    it "should work on input buffer by default" do
      File.open(DbAgile::Fixtures::basic_values_path, "r"){|io|
        dba.input_buffer = io
        dba.bulk_import %w{--ruby --drop-table basic_values_copy}
        dba.sql_send "UPDATE basic_values_copy SET ruby_nil = null"
      }
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end
  
    it "should accept a --input option" do
      dba.bulk_import ['--input', DbAgile::Fixtures::basic_values_path] + %w{--ruby --drop-table basic_values_copy}
      dba.sql_send "UPDATE basic_values_copy SET ruby_nil = null"
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
  
  # --dry-run
  describe "When a --dry-run option is set" do
    
    it "should do nothing at all" do
      dba.with_current_connection do |c|
        dba.environment.with_testing_methods!
        if c.has_table?(:basic_values_copy)
          c.transaction{|t| t.drop_table(:basic_values_copy)}
        end
      end
      File.open(DbAgile::Fixtures::basic_values_path, "r"){|io|
        dba.input_buffer = io
        dba.output_buffer = StringIO.new 
        dba.bulk_import %w{--dry-run --ruby --create-table basic_values_copy}
        dba.environment.should have_flushed(/CREATE TABLE/)
      }
      dba.with_current_connection do |c|
        c.has_table?(:basic_values_copy).should be_false
      end
    end
    
  end
  
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