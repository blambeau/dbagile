it "should support standard CRUD scheme" do
  
  db.transaction do |t|
    # Create
    t.fact!(:tools, {:'#' => 1, :name => "facts", :version => Facts::VERSION, :great => false})
    
    # Read
    t.fact?(:tools, {:'#' => 1}).should be_true
    t.fact(:tools, {:'#' => 1}, :great).should == false

    # Update
    t.fact!(:tools, {:'#' => 1, :great => true})
    
    # Re-read
    t.fact?(:tools, {:'#' => 1}).should be_true
    t.fact(:tools, {:'#' => 1}, :great).should == true
    
    # Delete
    t.nofact!(:tools, {:'#' => 1})
    t.fact?(:tools, {:'#' => 1}).should be_false
  end
  
end