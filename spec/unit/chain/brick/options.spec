require File.expand_path('../../../../spec_helper', __FILE__)
describe "::FlexiDB::Chain::Brick#options" do
  
  let(:defbrick){ 
    class DefBrick < ::FlexiDB::Chain::Brick
      def default_options() {:default => 12} end
    end
    DefBrick
  }
  
  describe "When initialize with default options without overriding" do
    subject{ defbrick.new(nil, :name => "flexidb").options }
    it { should == {:default => 12, :name => "flexidb"} }
  end

  describe "When initialize with default options with overriding" do
    subject{ defbrick.new(nil, :default => 1, :name => "flexidb").options }
    it { should == {:default => 1, :name => "flexidb"} }
  end

end