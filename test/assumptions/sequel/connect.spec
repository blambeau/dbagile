require File.expand_path('../../fixtures', __FILE__)
describe "Sequel::connect /" do

  let(:uris){[
    'postgres://nosuchuser@localhost/nosuch_database',
    'sqlite://tmp/test.db',
    'mysql://nosuchuser@localhost/nosuch_database',
    'dbi-frontbase://nosuchuser@localhost/nosuch_database',
    'dbi-mysql://nosuchuser@localhost/nosuch_database',
    'dbi-oracle://nosuchuser@localhost/nosuch_database',
    'dbi-msql://nosuchuser@localhost/nosuch_database',
  ]}

  it "allows connecting and using SQL tools on unexisting databases" do
    uris.each{|uri|
      lambda{ 
        db = Sequel::connect(uri)
        gen = Sequel::Schema::Generator.new(db){
          column :id, Integer
          column :name, String
          primary_key [:id]
        }
        res = db.send(:create_table_sql, :mytable, gen, {})
        puts res
        res.should =~ /CREATE TABLE/
      }.should_not raise_error
    }
  end

end