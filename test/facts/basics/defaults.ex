it "should support default value at fact retrieval time" do
  
  db.transaction do |t|
    # Create
    t.fact!(:tools, {:'#' => 1, :name => "facts", :version => Facts::VERSION})
    
    # No default -> nil
    t.fact(:tools, {:'#' => 1}, :great).should be_nil
    t.fact(:tools, {:'#' => 1}, [ :great ]).should == {}
    t.fact(:tools, {:'#' => 1}, [ :great ], {}).should == {}
    t.fact(:tools, {:'#' => 1}, :great, false).should == false
    t.fact(:tools, {:'#' => 1}, :great, {:great => true}).should == true
    t.fact(:tools, {:'#' => 1}, :great){|who| true}.should == true
    t.fact(:tools, {:'#' => 1}, [ :great ]){|who| true }.should == {:great => true}
    t.fact(:tools, {:'#' => 1}, [ :name, :great ]){|who| true }.should == {:name => "facts", :great => true}
  end
  
end