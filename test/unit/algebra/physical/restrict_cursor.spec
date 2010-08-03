require File.expand_path('../../../../spec_helper', __FILE__)

dbagile_load_all_subfiles(__FILE__, 'cursor/**/*.spec')

describe "DbAgile::Algebra::Physical::RestrictCursor" do
  
  let(:tuples) { (1..10).collect{|i| {:id => i}}                                    }
  let(:acursor){ DbAgile::Algebra::Physical::ArrayCursor.new(tuples, [:id])         }
  let(:rcursor){ DbAgile::Algebra::Physical::RestrictCursor.new(acursor, predicate) }
  subject{ rcursor }
  
  describe "with a true predicate" do
    let(:predicate){ lambda{|t| true} }
    
    it 'should return all tuples' do
      subject.to_a.should == tuples
    end
    
    it_should_behave_like("A cursor")
  end
  
  describe "with a false predicate" do
    let(:predicate){ lambda{|t| false} }
    
    it 'should return no tuple' do
      subject.to_a.should == []
    end
    
    it_should_behave_like("A cursor")
  end
  
  describe "with a % 2 predicate" do
    let(:predicate){ lambda{|t| t[:id] % 2 == 0} }
    
    it 'should return expected tuples' do
      expected = tuples.select{|t| t[:id] % 2 == 0}
      expected.size.should == 5
      subject.to_a.should == expected
    end
    
    it_should_behave_like("A cursor")
  end
  
  describe "with a not(% 2) predicate" do
    let(:predicate){ lambda{|t| t[:id] % 2 == 1} }
    
    it 'should return expected tuples' do
      expected = tuples.select{|t| t[:id] % 2 == 1}
      expected.size.should == 5
      subject.to_a.should == expected
    end
    
    it_should_behave_like("A cursor")
  end
  
end