require File.expand_path('../../../spec_helper', __FILE__)
require 'dbagile/facts'
describe "::DbAgile::Facts#fact!" do
  
  let(:uri){ "memory://test.db" }
  let(:factdb){ DbAgile::Facts::connect(uri) }
  
  context "when called with explicit tuples" do 
    let(:supplier_key){ { :'supplier#' => 1 } }
    let(:supplier){ {:'supplier#' => 1, :name => "Clark"} }
    context "when called with a name" do
      specify{ 
        factdb.fact!(:supplier, supplier).should == supplier_key
        factdb.connection.dataset(:supplier).to_a.should == [ supplier ]
      }
    end
    context "when called without a name" do
      specify{ 
        factdb.fact!(supplier).should == supplier_key
        factdb.connection.dataset(:'supplier').to_a.should == [ supplier ]
      }
    end
    context "when called two times with the same fact" do
      specify{ 
        factdb.fact!(supplier).should == supplier_key
        factdb.fact!(supplier).should == supplier_key
        factdb.connection.dataset(:'supplier').to_a.should == [ supplier ]
      }
    end
  end
  
  # context "when called with implicit tuples" do
  #   let(:supplier){ {:'#' => DbAgile::Facts::_, :name => "Clark" }}
  #   specify{
  #     10.times do |i|
  #       factdb.fact!(supplier).should == {:'#' => i}
  #     end
  #   }
  # end
  
end

