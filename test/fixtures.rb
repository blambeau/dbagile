module DbAgile
  #
  # Provides helper methods about fixture databases
  #
  module Fixtures
    include DbAgile::Environment::Delegator
    
    # Returns the fixture environment
    def environment
      env = DbAgile::Environment.new 
      env.config_file_path = File.expand_path('../fixtures/configs/dbagile.config', __FILE__)
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
        dba.config_file.each do |config|
          if config.ping?
            puts "Installing fixture database on #{config.name.inspect}"
            dba.use(config.name)
            each_table_file{|name, file|
              dba.import ["--ruby", "--drop-table", "--create-table", "--input=#{file}", name]
            }
          else
            puts "Skipping fixture database #{config.name.inspect} (no ping)"
          end
        end
      end
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