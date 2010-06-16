require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::MemoryAdapter::Table#count" do
  
  let(:heading){ {:id => Integer, :version => String, :name => String} }
  let(:tuples){ [
    {:id => 1, :version => DbAgile::VERSION, :name => "dbagile"},
    {:id => 2, :version => "3.8.0", :name => "sequel"},
  ] }
  let(:table){ DbAgile::MemoryAdapter::Table.new(heading, tuples) }
  
  specify{ 
    table.count.should == 2
    table.truncate!
    table.count.should == 0
  }
  
end
  
