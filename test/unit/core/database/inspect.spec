require File.expand_path('../fixtures', __FILE__)
describe "DbAgile::Core::Database#inspect /" do

  describe "When no prefix is given" do
    let(:database_str){ %Q{database(:test){\n  uri "sqlite://test.db"\n}} }
    let(:database)    { Kernel.eval("DbAgile::" + database_str) }
    subject{ database.inspect }
    it{ should == database_str }
  end

  describe "When a specific prefix is given" do
    let(:database_str){ %Q{database(:test){\n  uri "sqlite://test.db"\n}} }
    let(:database)    { Kernel.eval("DbAgile::" + database_str) }
    subject{ database.inspect("Hello::") }
    it{ should == "Hello::" + database_str }
  end

end
  
