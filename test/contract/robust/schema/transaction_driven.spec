shared_examples_for "A robust Contract::Schema::TransactionDriven" do

  it "should raise a TableAlreadyExistsError on create_table if name is already in use" do
  
    subject.has_table?(:basic_values).should be_true

    lambda{ subject.create_table(:basic_values, :id => Integer) }.should raise_error(DbAgile::TableAlreadyExistsError)
  
  end

  it "should raise a NoSuchTableError on drop_table if the table does not exist" do
  
    subject.has_table?(:unexisting).should be_false

    lambda{ subject.drop_table(:unexisting) }.should raise_error(DbAgile::NoSuchTableError)
  
  end

end