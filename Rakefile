require "rubygems"
require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "yard"

# Some utils
dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "dbagile.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

# Default task is spec
task :default => [:test]

# Creates the fixtures
desc "Creates physical SQL test databases"
task :physical_databases do
  $LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../test', __FILE__))
  require 'dbagile'
  require 'fixtures'
  DbAgile::Fixtures::ensure_physical_databases!
end

desc "Creates test fixture databases"
task :fixtures do
  $LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../test', __FILE__))
  require 'dbagile'
  require 'fixtures'
  DbAgile::Fixtures::create_fixtures
end

require "rspec/core/rake_task"
tests = Dir[File.expand_path('../test/*.spec', __FILE__)].collect{|f| File.basename(f, '.spec')}
tests.each do |kind|
  desc "Run #{kind} spec tests"  
  RSpec::Core::RakeTask.new("#{kind}_test".to_sym) do |t|
    t.ruby_opts = ['-I.']
    t.pattern = "test/#{kind}.spec"
  end
end

desc "Install physical fixtures the run all spec tests"
task :spec => :fixtures do
  load(File.expand_path('../test/run_all_suite.rb', __FILE__))
end

desc "Run all spec tests directly"
task :suite do
  load(File.expand_path('../test/run_all_suite.rb', __FILE__))
end

# About yard documentation
YARD::Rake::YardocTask.new do |t|
  YARD::Tags::Library.define_tag "Precondition", :pre
  YARD::Tags::Library.define_tag "Postcondition", :post
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', 'doc/api', '-', 
               "README.textile", "LICENCE.textile", 
               "CHANGELOG.textile", "TODO.textile"]
end

# About gem specification
gemspec = Kernel.eval(File.read("dbagile.gemspec"))
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
