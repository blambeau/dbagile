puts File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'dbagile'
require 'fileutils'

FileUtils.rm_rf('test.rb')

config = DbAgile::config do
  plug AgileKeys, AgileTable
end

n = 100
t1 = Time.now
db = config.connect("sqlite://test.db")
db.transaction do |t|
  n.times do |i|
    t.insert(:example, {:'s#' => i})
  end
end
t2 = Time.now

puts "Inserts done in #{t2-t1} sec, i.e. #{n/(t2.to_f-t1.to_f)} inserts by second"