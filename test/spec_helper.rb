$LOAD_PATH.unshift(File.expand_path('../', __FILE__))
$LOAD_PATH.unshift(File.expand_path('../../lib', __FILE__))

require 'dbagile'
require 'rubygems'
require 'fixtures'
require 'fileutils'

def dbagile_load_all_subfiles(requester_file, match)
  Dir[File.expand_path("../#{match}", requester_file)].each{|f| load(f)}
end

def dbagile_load_all_subspecs(requester_file, name = File.basename(requester_file, ".spec"))
  dbagile_load_all_subfiles(requester_file, "#{name}/**/*.spec")
end

def dbagile_install_examples(requester_file, requester)
  match = "../#{File.basename(requester_file, '.spec')}/**/*.ex"
  Dir[File.expand_path(match, requester_file)].each do |file|
    requester.instance_eval File.read(file)
  end
end

dbagile_load_all_subfiles(__FILE__, "support/*.rb")