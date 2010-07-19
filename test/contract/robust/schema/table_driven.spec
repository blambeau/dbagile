shared_examples_for "A robust Contract::Schema::TableDriven" do

  it "should raise a NoSuchTableError on column_names when table does not exists" do
  
    lambda { subject.column_names(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

  it "should raise a NoSuchTableError on has_column? when table does not exists" do
  
    lambda { subject.has_column?(:unexisting, :id) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

  it "should raise a NoSuchTableError on heading when table does not exists" do
  
    lambda { subject.heading(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

end