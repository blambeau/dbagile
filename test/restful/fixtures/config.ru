#!/usr/bin/env rackup --require dbagile/restful/middleware -p 8711
app = DbAgile::Restful::Middleware.new{|env|
  #
  # Set the environment!
  #
  # WARNING: Always use ::File instead of File because constants are
  #          resolved in Rack scope, which contains a File class. Not
  #          doing this may mead to bugs in certain ruby versions.
  #
  env.config_file_path  = ::File.expand_path('../../../fixtures/configs/dbagile.config', __FILE__)
  env.history_file_path = nil
}
map '/' do
  run Rack::File.new(::File.dirname(__FILE__))
end
map '/debug' do
  run lambda{|env|
    puts "ENV ------------------------------"
    env.each_pair{|k,v|
      puts "#{k}: #{v.inspect}"
    }
    request = Rack::Request.new(env)
    puts "GET ------------------------------"
    request.GET.each_pair{|k,v|
      puts "#{k}: #{v.inspect}"
    }
    puts "POST ------------------------------"
    request.POST.each_pair{|k,v|
      puts "#{k}: #{v.inspect}"
    }
    puts "params ------------------------------"
    request.params.each_pair{|k,v|
      puts "#{k}: #{v.inspect}"
    }
    [ 302, {'Content-Type' => 'text/plain', 'Location' => 'client.html'}, [] ]
  }
end
map '/data' do
  run app
end