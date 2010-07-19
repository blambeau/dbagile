shared_examples_for "A Contract::Data::TransactionDriven" do

  ::DbAgile::Contract::Data::TransactionDriven.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  Dir[File.expand_path('../transaction_driven/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end