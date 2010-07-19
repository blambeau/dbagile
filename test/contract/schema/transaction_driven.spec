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
  
  Dir[File.expand_path('../transaction_driven/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end