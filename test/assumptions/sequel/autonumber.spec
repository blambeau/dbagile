require File.expand_path('../../fixtures', __FILE__)
describe "auto number on sequel /" do

  let(:db_file){ File.expand_path('../test.db', __FILE__) } 
  let(:db){ Sequel::connect("sqlite://#{db_file}") }
  before{
    if db.table_exists?(:test)
      db.drop_table(:test)
    end
  }

  it "should be supported at primary key time" do
    db.create_table(:test){
      column :id, :integer
      primary_key :id, :auto_increment => true
    }
  end

end