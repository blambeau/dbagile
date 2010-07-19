shared_examples_for("A Contract::Connection") do
  
  ::DbAgile::Contract::Connection.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  Dir[File.expand_path('../connection/**/*.ex', __FILE__)].each do |file|
    self.instance_eval File.read(file)
  end

end
