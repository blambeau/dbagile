#!/usr/bin/env rackup -rsupport -p 9292
map "/" do
  run ::Rack::File.new(::File.expand_path('../source/public', __FILE__))
end
map "/doc" do
  run ::DbAgile::Doc::Browse.new
end