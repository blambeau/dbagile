#!/usr/bin/env rackup --require dbagile/restful -p 8711
app = DbAgile::Restful.new{|env|
  #
  # Set the environment!
  #
  # WARNING: Always use ::File instead of File because constants are
  #          resolved in Rack scope, which contains a File class. Not
  #          doing this may mead to bugs in certain ruby versions.
  #
  env.config_file_path  = ::File.expand_path('../dbagile.config', __FILE__)
  env.history_file_path = nil
}
run app
