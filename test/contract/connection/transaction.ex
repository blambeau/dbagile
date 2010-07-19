it "should give a transaction object" do
  
  if subject.ping?

    subject.transaction do |t|
      t.should be_kind_of(::DbAgile::Core::Transaction)
    end

  end
  
end