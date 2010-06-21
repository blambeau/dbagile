it "should support returning fact on a name/id pair" do

  db.transaction{|t| t.fact!(:people, {:'#' => 1, :name => "facts"})}
  
  f = db.fact(:people, :'#' => 1)
  f[:name].should == "facts"
  
end