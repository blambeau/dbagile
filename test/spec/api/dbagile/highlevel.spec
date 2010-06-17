require File.expand_path('../../../spec_helper', __FILE__)
require 'fileutils'
describe "DbAgile's API" do
  
  before{
    file = File.expand_path('../dbagile.db', __FILE__)
    FileUtils.rm_rf(file)
  }
  after{
    file = File.expand_path('../dbagile.db', __FILE__)
    FileUtils.rm_rf(file)
  }
  
  context "coucou" do  
    specify{
      12.should == 12
      file = File.expand_path('../dbagile.db', __FILE__)
      conn = DbAgile::config(:agile){
        uri  "sqlite://#{file}"
        plug AgileKeys, AgileTable
      }.connect
      begin
        conn.transaction do |t|
          t.create_table(:people, {:id => Integer})
          t.insert(:people, {:id => 1})
#          t.rollback
        end
      rescue DbAgile::Adapter::AbordTransactionError
        conn.dataset(:people).to_a.should = []
      end
    }
  end
  
end