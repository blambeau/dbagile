require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::Database::execute" do
  
  let(:adapter){ DbAgile::MemoryAdapter.new }
  let(:database){ DbAgile::connect(adapter) }
  let(:source){ lambda{
    use :AgileTable
    insert :people, {:id => 1}
  }}
  
  context "when called with a source object" do
    subject{ database.execute(source) }
    specify {
      subject.should == database
      database.dataset(:people).to_a.should == [{:id => 1}]
    }
  end
  
  context "when called with a proc object" do
    subject{ database.execute(&source) }
    specify {
      subject.should == database
      database.dataset(:people).to_a.should == [{:id => 1}]
    }
  end
  
  context "when called with something that leads to an error" do
    subject{ lambda{ database.execute{ skjhqkdjhq } } }
    it{ should raise_error(DbAgile::Engine::NoSuchCommandError) }
  end
  
end