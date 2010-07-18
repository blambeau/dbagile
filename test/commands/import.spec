shared_examples_for("The import command") do
  
  # --ruby
  
  describe "When used with a --ruby option" do

    it "should work on input buffer by default" do
      File.open(DbAgile::Fixtures::basic_values_path, "r"){|io|
        dba.input_buffer = io
        dba.import %w{--ruby --drop-table basic_values_copy}
      }
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end

    it "should accept a --input option" do
      dba.import ['--input', DbAgile::Fixtures::basic_values_path] + %w{--ruby --drop-table basic_values_copy}
      dba.dataset(:basic_values_copy).to_a.should == DbAgile::Fixtures::basic_values
    end

  end # --ruby
  
end