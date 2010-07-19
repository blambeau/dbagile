shared_examples_for "A Contract::Data::TransactionDriven" do

  ::DbAgile::Contract::Data::TransactionDriven.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  after(:each){ 
    subject.delete(:empty_table)     
  }
  after(:each){ 
    subject.delete(:non_empty_table) 
    subject.insert(:non_empty_table, :id => 1, :english => "One")
    subject.insert(:non_empty_table, :id => 2, :english => "Two")
  }
  
  Dir[File.expand_path('../transaction_driven/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end