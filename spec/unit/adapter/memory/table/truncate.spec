require File.expand_path('../../../../../spec_helper', __FILE__)
describe "::DbAgile::MemoryAdapter::Table.check_key" do
  
  let(:heading){ {:id => Integer, :version => String, :name => String} }
  let(:tuples){ [
    {:id => 1, :version => DbAgile::VERSION, :name => "dbagile"},
    {:id => 2, :version => "3.8.0", :name => "sequel"},
  ] }
  let(:table){ DbAgile::MemoryAdapter::Table.new(heading, tuples) }
  
  specify{ 
    table.truncate!
    table.to_a.should == []
  }
  
end
  
