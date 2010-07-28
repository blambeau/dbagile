require 'stringio'
module DbAgile
  #
  # Provides helper methods about fixture databases
  #
  module Fixtures
    include DbAgile::Environment::Delegator
    include DbAgile::Tools::Tuple
    
    # Returns the fixture environment
    def environment
      env = DbAgile::Environment.new 
      env.repository_path = File.expand_path('../fixtures/configs/dbagile.config', __FILE__)
      env.history_file_path = File.expand_path('../fixtures/configs/dbagile.history', __FILE__)
      env.output_buffer = StringIO.new
      env.console_width = 10
      env
    end
    
    # Returns the path to the table/basic_values.rb file
    def basic_values_path
      File.expand_path('../fixtures/tables/basic_values.rb', __FILE__)
    end
    
    # Yields the block with each table file in turn
    def each_table_file
      Dir[File.expand_path('../fixtures/tables/*.rb', __FILE__)].each{|file| 
        name = File.basename(file, ".rb")
        yield(name, file)
      }
    end
    
    # Creates the physical databases for fixtures
    def create_physical_databases
      FileUtils.rm_rf '/tmp/test.db'
      FileUtils.rm_rf '/tmp/robust.db'
      require 'readline'
      puts "#################################################################################"
      puts "ATTENTION: This task will create physical test databases on your computer"
      puts "           A password will probably be asked as this task relies on 'sudo'."
      puts "           Please provide the root password"
      puts "#################################################################################"
      Readline.readline("Press enter to start")
      puts "Creating the physical postgresql database ..."
      puts `sudo su postgres -c 'dropdb dbagile_test'`
      puts `sudo su postgres -c 'dropuser dbagile'`
      puts `sudo su postgres -c 'createuser --no-superuser --no-createrole --createdb dbagile'`
      puts `sudo su postgres -c 'createdb --encoding=utf8 --owner=dbagile dbagile_test'`
      puts 
      puts "#################################################################################"
      puts "Done."
      puts "Please run 'rake fixtures'"
      puts "#################################################################################"
      true
    end
    
    # Ensures that physical databases are created
    def ensure_physical_databases!
      @ensure_physical_databases ||= create_physical_databases
    end
    
    # Creates logical fixtures
    def create_fixtures
      ensure_physical_databases!
      DbAgile::dba(environment) do |dba|
        dba.output_buffer = STDOUT
        dba.console_width = nil
        dba.repository.each do |db|
          if db.ping?
            puts "Installing fixture database on #{db.name.inspect}"
            dba.config_use(db.name)
            each_table_file{|name, file|
              dba.bulk_import ["--ruby", "--drop-table", "--create-table", "--input=#{file}", name]
            }
            dba.sql_send "DELETE FROM empty_table"
          else
            puts "Skipping fixture database #{db.name.inspect} (no ping)"
          end
        end
      end
    end
    
    # Returns basic_values tuple
    def basic_values_tuple
      basic_values[0]
    end
    
    # Returns basic_values keys (sorted by name)
    def basic_values_keys
      basic_values_tuple.keys.sort{|a,b| a.to_s <=> b.to_s}
    end

    # Returns basic_values heading
    def basic_values_heading
      heading = {}
      basic_values[0].each_pair do |key, value|
        heading[key] = case value
          when NilClass
            String
          when TrueClass, FalseClass
            SByC::TypeSystem::Ruby::Boolean
          when Fixnum, Bignum
            Integer
          else
            value.class
        end
      end
      heading
    end
    
    # Empty the basic values on a db
    def empty_basic_values(db)
      db.with_connection{|c|
        c.transaction{|t| t.delete(:basic_values) }
      }
    end
    
    # Restored the basic values on a db
    def restore_basic_values(db)
      db.with_connection{|c|
        c.transaction{|t| 
          t.delete(:basic_values) 
          t.insert(:basic_values, basic_values[0])
        }
      }
    end
    
    # Adds class methods now
    extend Fixtures
    
    # Provide helpers to get the contents of the tables
    each_table_file do |name, file|
      define_method name do
        Kernel.eval(File.read(file))
      end
    end

  end # module Fixtures
end # module DbAgile