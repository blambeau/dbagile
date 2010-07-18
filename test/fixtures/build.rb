#
# Creating the postgresql database first:
#   createuser --no-superuser --no-createrole --createdb dbagile
#   createdb --encoding=utf8 --owner=dbagile dbagile_test
#

$LOAD_PATH.unshift(File.expand_path('../../../lib', __FILE__))
require 'dbagile'
require 'sbyc/type_system/ruby'
require 'fileutils'
require 'date'
require 'time'

files = Dir[File.expand_path('../tables/*.rb', __FILE__)].collect{|file| 
  name = File.basename(file, ".rb")
  [name, file]
}

DbAgile::command do |env, dba|
  # Set configuration
  env.config_file_path = File.expand_path('../../configs/dbagile.config', __FILE__)
  env.history_file_path = nil
  env.output_buffer = []
  
  env.config_file.each do |config|
    if dba.ping(config.name).kind_of?(StandardError)
      puts "Skipping fixture database #{config.name.inspect} (no ping)"
    else
      puts "Installing fixture database on #{config.name.inspect}"
      dba.use(config.name)
      files.each{|pair|
        name, file = pair
        dba.import ["--ruby", "--drop-table", "--create-table", "--input=#{file}", name]
      }
    end
  end
end
