require File.expand_path("../../spec_helper", __FILE__)
describe "The basic contract" do
  it "should support keys" do
  
    Fixtures::adapters_under_test.each do |adapter|
      db = DbAgile.connect(adapter)

      # Creates the tables
      db.create_table(:tools, :id => Integer, :name => String, :version => String)
      db.key(:tools, [:id])
      db.key(:tools, [:name, :version])

      # Insert inside the tables
      db.insert(:tools, :id => 1, :name => "dbagile", :version => "0.0.1")
      db.insert(:tools, :id => 2, :name => "sequel",  :version => "3.8.0")

      lambda{ db.insert(:tools, :id => 1, :name => "other", :version => "0.0.1") }.should raise_error
      lambda{ db.insert(:tools, :id => 3, :name => "dbagile", :version => "0.0.1") }.should raise_error
      lambda{ db.insert(:tools, :id => 3, :name => "dbagile", :version => "0.0.2") }.should_not raise_error
    end

  end
end