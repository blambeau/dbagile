require File.expand_path('../../../spec_helper', __FILE__)
require 'fileutils'
describe "DbAgile's API" do
  
  before{
    file = File.expand_path('../dbagile.db', __FILE__)
    FileUtils.rm_rf(file)
    DbAgile::config(:agile){
      uri  "sqlite://#{file}"
      plug AgileKeys, AgileTable
    }
  }
  after{
    file = File.expand_path('../dbagile.db', __FILE__)
    FileUtils.rm_rf(file)
  }
  
  
  specify{
    conn = DbAgile::connect(:agile)
    conn.transaction do |t|
      t.insert(:people, {:id => 1})
      t.rollback
    end
    conn.dataset(:people).to_a.should = []
  }
  
end