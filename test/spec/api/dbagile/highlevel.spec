require File.expand_path('../../../spec_helper', __FILE__)
require 'fileutils'
describe "DbAgile's API" do
  
  let(:file){ File.expand_path('../dbagile.db', __FILE__) }
  let(:config){
    DbAgile::config(:agile){
      uri  "sqlite://#{File.expand_path('../dbagile.db', __FILE__)}"
      plug AgileKeys, AgileTable
    }    
  }
  
  before(:each){
    config.connect.transaction do |t|
      t.create_table(:people, {:id => Integer})
    end
  }
  after(:each){
    FileUtils.rm_rf(file)
  }
  
  it "should support transactions" do
    conn = config.connect
    begin
      conn.transaction do |t|
        t.insert(:people, {:id => 1})
        t.rollback
      end
    rescue DbAgile::Adapter::AbordTransactionError
      conn.dataset(:people).to_a.should == []
    end
  end
  
end