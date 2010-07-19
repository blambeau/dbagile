shared_examples_for "A Contract::Data::Dataset" do

  ::DbAgile::Contract::Data::Dataset.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  Dir[File.expand_path('../dataset/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end