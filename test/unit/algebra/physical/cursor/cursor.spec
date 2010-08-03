shared_examples_for("A cursor") do
  
  it 'should be an enumerable' do
    subject.collect{|t| t}.should == subject.to_a
  end
  
  it 'should return tuples in same order as to_a' do
    got = []
    while subject.has_next?
      got << subject.next
    end
    got.should == subject.to_a
  end
  
  it 'should return the same value on current/next the first time' do
    subject.current.should == subject.next
  end
  
  it "should support resetting" do
    first = subject.next
    while subject.has_next?
      subject.next
    end
    subject.reset.should == first
  end
  
  it "should support rewinding" do
    mark, first = subject.mark, subject.next
    while subject.has_next?
      subject.next
    end
    subject.rewind(mark).should == first
  end
  
  it 'should support rewinding to the current mark' do
    subject.current.should == subject.rewind(subject.mark)
  end
  
end