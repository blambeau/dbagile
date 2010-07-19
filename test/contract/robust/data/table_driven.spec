shared_examples_for "A robust Contract::Data::TableDriven" do

  it "should raise a NoSuchTableError on dataset when table does not exists" do
  
    lambda { subject.dataset(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

  it "should raise a NoSuchTableError on exists? when table does not exists" do
  
    lambda { subject.exists?(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

end