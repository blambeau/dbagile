require File.expand_path('../../../spec_helper', __FILE__)
describe "DbAgile::Database::build_delegates" do
  
  let(:database){ ::DbAgile::Database.new(nil) }
  
  context "when called with a module and no options" do
    subject{ database.build_delegates(DbAgile::Plugin::AgileTable) }
    specify{
      subject.size.should == 1
      subject[0].should be_kind_of(DbAgile::Plugin::AgileTable)
    }
  end
  
  context "when called with multiple modules without options" do
    subject{ database.build_delegates(DbAgile::Plugin::AgileTable, DbAgile::Plugin::AgileKeys) }
    specify{
      subject.size.should == 2
      subject[0].should be_kind_of(DbAgile::Plugin::AgileTable)
      subject[1].should be_kind_of(DbAgile::Plugin::AgileKeys)
    }
  end
  
  context "when called with an instance" do
    let(:inst){ DbAgile::Plugin::AgileTable.new(nil) }
    subject{ database.build_delegates(inst) }
    specify{
      subject.size.should == 1
      subject[0].should == inst
    }
  end
  
  context "when called with a previously built instance" do
    let(:inst){ DbAgile::Plugin::AgileTable[:hello => "world"] }
    subject{ database.build_delegates(inst) }
    specify{
      subject.size.should == 1
      subject[0].should == inst
      subject[0].options[:hello].should == "world"
    }
  end
  
  context "when called with a mix" do
    subject{ database.build_delegates(DbAgile::Plugin::AgileTable, DbAgile::Plugin::Defaults[:hello => "world"]) }
    specify{
      subject.size.should == 2
      subject[0].should be_kind_of(DbAgile::Plugin::AgileTable)
      subject[1].should be_kind_of(DbAgile::Plugin::Defaults)
      subject[1].send(:__do_touch, {}).should == {:hello => "world"}
    }
  end
  
  context "when called with a strange mix" do
    subject{ database.build_delegates(DbAgile::Plugin::AgileTable, DbAgile::Plugin::Defaults, {:hello => "world"}) }
    specify{
      subject.size.should == 2
      subject[0].should be_kind_of(DbAgile::Plugin::AgileTable)
      subject[1].should be_kind_of(DbAgile::Plugin::Defaults)
      subject[1].send(:__do_touch, {}).should == {:hello => "world"}
    }
  end
  
end
  
