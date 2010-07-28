require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Schema#stage_operations" do
  
  let(:announced) { DbAgile::Fixtures::Core::Schema::schema(:left)  }
  let(:effective) { DbAgile::Fixtures::Core::Schema::schema(:right) }
  
  it "should compute the operation list correctly" do
    merged = DbAgile::Core::Schema::merge(effective, announced){|l,r| nil}
    ops = DbAgile::Core::Schema::stage_operations(merged, {:expand => true, :collapse => true})
    ops.should be_kind_of(Array)
    ops.each{|op|
      case op.kind
        when :create_table
          op.operations.size.should >= 1
        when :drop_table
        when :expand_table
          op.operations.size.should == 1
        when :collapse_table
          op.operations.size.should == 1
        else
          raise "Unexpected operation kind #{op.kind}"
      end
    }
  end

end