shared_examples_for("A Contract::Connection") do
  
  ::DbAgile::Contract::Connection.instance_methods(false).each do |meth|
    it { should respond_to(meth) }
  end
  
  dbagile_install_examples(__FILE__, self)

end
