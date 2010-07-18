$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'dbagile'
require 'rubygems'
require 'fileutils'

DbAgile::dba do |dba|
  dba.config_file_path = File.expand_path('../dbagile.config', __FILE__)
  dba.history_file_path = nil
  dba.output_buffer = nil

  # Use the first one and export the suppliers table in a StringIO object
  dba.use %w{source}
  dba.output_buffer = StringIO.new
  exported = dba.export(%w{--csv --type-safe suppliers}).string.dup

  # Now use the second one and import the table
  dba.use %w{target}
  dba.input_buffer = StringIO.new(exported)
  dba.import %w{--csv --create-table --type-safe suppliers}
  
  # Show the result
  dba.output_buffer = STDOUT
  dba.show %w{suppliers}
end