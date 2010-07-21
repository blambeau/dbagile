#!/usr/bin/env rackup -rsupport -p 9292
map "/" do
  run ::Rack::File.new(::File.expand_path('../public', __FILE__))
end
map "/doc" do
  run lambda{|env|
    begin 
      path = env['PATH_INFO'].strip[1..-1]
      file = ::File.expand_path("../#{path}.wtxt", __FILE__)
      if ::File.exists?(file)
        wlanged = ::WLang::file_instantiate(file, {})
        redclothed = ::RedCloth.new(wlanged).to_html
        template = ::File.expand_path("../templates/basic.wtpl", __FILE__)
        context = {:base => "http://127.0.0.1:9292/",
                   :body => redclothed}
        wlanged = ::WLang::file_instantiate(template, context)
        [ 200, {'Content-Type' => 'text/html'}, [ wlanged ] ]
      else
        [ 404, {'Content-Type' => 'text/plain'}, [ "No such file #{file}" ] ]
      end
    rescue Exception => ex
      [ 500, {'Content-Type' => 'text/plain'}, [ ex.message, ex.backtrace.join("\n") ] ]
    end
  }
end