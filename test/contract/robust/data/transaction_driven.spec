shared_examples_for "A robust Contract::Data::TransactionDriven" do

  it "should raise a NoSuchTableError on delete when table does not exists" do
  
    lambda { subject.delete(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

  it "should raise a NoSuchTableError on insert when table does not exists" do
  
    lambda { subject.insert(:unexisting, :id => 1) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

  it "should raise a NoSuchTableError on update when table does not exists" do
  
    lambda { subject.update(:unexisting, :id => 1) }.should raise_error(DbAgile::NoSuchTableError)
  
  end
  
end