#!/usr/bin/env rackup --require dbagile/restful -p 8711
app = DbAgile::Restful.new{|env|
  env.config_file_path  = ::File.expand_path('../dbagile.config', __FILE__)
  env.history_file_path = nil
}
run app