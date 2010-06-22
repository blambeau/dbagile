it "should be robust to strange requests" do
  
  db.fact!(:people, {:'#' => 1})
  
  db.facts(:people, {}).should be_kind_of(Array)
  db.fact(:people, {:'#' => 1}).should be_kind_of(Hash)
  
end
  
