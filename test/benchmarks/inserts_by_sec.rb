require File.expand_path("../../spec_helper.rb", __FILE__)
env = DbAgile::Fixtures::environment
x = 10000
env.each_database{|db|
  next unless db.ping?
  
  begin
    db.with_connection do |c|
      c.transaction do |t|
        t.create_table(:dbagile_benchmarks_inserts_by_sec, {:id => Integer, :name => String})
      end
    end
  rescue => ex
    puts "Unable to create table data #{ex.message}"
  end
  
  begin
    puts "Running inserts/sec on #{db.name}"
    t1 = Time.now
    db.with_connection do |c|
      c.transaction do |t|
        x.times do |i|
          t.insert(:dbagile_benchmarks_inserts_by_sec, :id => i, :name => "#{i}")
        end
      end
    end
    t2 = Time.now
    i_by_s = x.to_f/(t2-t1)
    s_by_i = (t2-t1).to_f/x.to_f
    puts "#{x} inserts took #{t2-t1} sec: #{i_by_s} inserts/sec, #{s_by_i} sec/insert"
  rescue StandardError => ex
    puts "Failed: #{ex.message}"
    puts ex.join("\n")
  ensure
    db.with_connection{|c|
      c.transaction{|t|
        t.drop_table(:dbagile_benchmarks_inserts_by_sec)
      }
    }
  end
}