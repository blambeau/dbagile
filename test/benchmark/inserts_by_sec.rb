puts File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'dbagile'
require 'fileutils'

n = 1000
t1, t2 = 0, 0
file = File.expand_path('../test.db', __FILE__)
uri = "sqlite://#{file}"
#uri = "postgres://istluc@localhost/istluc"

def drop_table(file, uri)
#  Sequel::connect(uri) << "DROP TABLE dbagile_bench"
  FileUtils.rm_rf(file)
end

# drop_table(file, uri)
# puts "Making #{n} inserts with Sequel directly"
# db = Sequel::connect(uri)
# db << "CREATE TABLE dbagile_bench (id INTEGER primary key)"
# table = db[:dbagile_bench]
# t1 = Time.now
# n.times do |i|
#   table.insert(:id => i)
# end
# t2 = Time.now
# puts "Inserts done in #{t2-t1} sec, i.e. #{n/(t2.to_f-t1.to_f)} inserts by second"

drop_table(file, uri)
puts "Making #{n} inserts with DbAgile directly"
db = DbAgile::connect(uri, {:sequel_logger => Logger.new(STDOUT)})
db.transaction do |t|
  t.create_table(:dbagile_bench, :id => Integer)
  t.key!(:dbagile_bench, :id)
  t1 = Time.now
  n.times do |i|
    t.insert(:dbagile_bench, {:id => i})
  end
  t2 = Time.now
end
db.disconnect
puts "Inserts done in #{t2-t1} sec, i.e. #{n/(t2.to_f-t1.to_f)} inserts by second"

drop_table(file, uri)
puts "Making #{n} inserts with DbAgile and agile plugins"
db = DbAgile::config(:test){
  plug AgileKeys[:candidate => /^id$/], AgileTable.new
}.connect(uri, {:sequel_logger => Logger.new(STDOUT)})
db.transaction do |t|
  t1 = Time.now
  n.times do |i|
    t.insert(:dbagile_bench, {:id => i})
  end
  t2 = Time.now
end
db.disconnect
puts "Inserts done in #{t2-t1} sec, i.e. #{n/(t2.to_f-t1.to_f)} inserts by second"
