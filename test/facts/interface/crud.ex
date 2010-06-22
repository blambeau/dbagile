it "should support standard CRUD scheme" do
  # Create
  fact = int.fact!(:tools, {:'#' => 1, :name => "facts", :version => Facts::VERSION, :great => false})
  fact[:'#'].should == 1
  fact[:great].should == false
   
  # Query
  int.fact?(:tools, {:'#' => 1}).should == true
  int.fact?(:tools, {:'#' => 2}).should == false
   
  # Update
  fact = int.fact!(:tools, {:'#' => 1, :great => true})
  fact[:great].should be_true

  # Read
  fact = int.fact(:tools, {:'#' => 1})
  fact[:great].should be_true

  # Read all
  facts = int.facts(:tools)
  facts.should be_kind_of(Array)
  facts[0][:great].should be_true
  
end