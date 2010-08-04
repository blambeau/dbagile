require File.expand_path('../../../../spec_helper', __FILE__)

dbagile_load_all_subfiles(__FILE__, 'cursor/**/*.spec')

describe "DbAgile::Algebra::Physical::TransformCursor" do
  
  let(:tuples) { (1..10).collect{|i| {:id => i}}                                    }
  let(:acursor){ DbAgile::Algebra::Physical::ArrayCursor.new(tuples, [:id])         }
  let(:tcursor){ DbAgile::Algebra::Physical::TransformCursor.new(acursor, modifier) }
  subject{ tcursor }
  
  describe "with a *2 transformer" do
    let(:modifier){ lambda{|t| {:id => t[:id]*2} } }
    
    it 'should return expected tuples' do
      expected = tuples.collect{|t| {:id => t[:id]*2} }
      subject.to_a.should == expected
    end
    
    it_should_behave_like("A cursor")
  end
  
end