shared_examples_for "A Contract::Schema::TransactionDriven" do

  ::DbAgile::Contract::Schema::TransactionDriven.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  before(:each){ 
    subject.drop_table(:unexisting) if subject.has_table?(:unexisting) 
    subject.create_table(:existing, :id => Integer) unless subject.has_table?(:existing)
  }
  after(:each){ 
    subject.drop_table(:unexisting) if subject.has_table?(:unexisting) 
    subject.drop_table(:existing)   if subject.has_table?(:existing) 
  }
  
  dbagile_install_examples(__FILE__, self)

end