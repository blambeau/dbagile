#!/usr/bin/env rackup -I. -r dotorg/main
map '/' do
  run DbAgile::DotOrg::Main.new
end
map '/convert' do
  run DbAgile::DotOrg::SchemaConverter.new
end
