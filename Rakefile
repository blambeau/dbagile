require "rubygems"
require "rake/rdoctask"
require "rake/testtask"
require 'spec/rake/spectask'
require "rake/gempackagetask"
require "yard"

# Some utils
dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "dbagile.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

####################################################################################
#TEST SUITE 
####################################################################################

# Default task is spec
task :default => [:test]

# Creates the fixtures
desc "Creates physical SQL test databases"
task :physical_databases do
  $LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))
  $LOAD_PATH.unshift(File.expand_path('../test', __FILE__))
  require 'fixtures'
  require 'dbagile'
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

# Install sub-spec test suite
tests = Dir[File.expand_path('../test/*.spec', __FILE__)].collect{|f| File.basename(f, '.spec')}
tests.each do |kind|
  desc "Run #{kind} spec tests"  
  Spec::Rake::SpecTask.new("#{kind}_test".to_sym) do |t|
    t.ruby_opts = ['-I.']
    t.spec_files = FileList["test/#{kind}.spec"]
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

####################################################################################
# DOCUMENTATION
####################################################################################

# yard
YARD::Rake::YardocTask.new do |t|
  YARD::Tags::Library.define_tag "Precondition", :pre
  YARD::Tags::Library.define_tag "Postcondition", :post
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', 'doc/api', '-', 
               "README.textile", "COMMAND_LINE.textile", 
               "LICENCE.textile", "CHANGELOG.textile", 
               "TODO.textile"]
end

task :"browse-doc" do
  puts "Have a loot at http://127.0.0.1:9292/"
  Kernel.system "cd doc && ./browse.ru"
end

####################################################################################
# GEM
####################################################################################

# About gem specification
gemspec = Gem::Specification.new do |s|
  s.name = 'dbagile'
  s.version = version
  s.summary = "DbAgile - Agile Interface on top of SQL Databases"
  s.description = %{Agile Interface on top of SQL Databases}
  s.files = Dir['lib/**/*'] + Dir['test/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENCE.textile", "COMMAND_LINE.textile"]
  s.rdoc_options << '--title' << 'DbAgile - Agile Interface on top of SQL Databases' <<
                    '--main' << 'README.textile' <<
                    '--line-numbers'  
  s.bindir = "bin"
  s.executables = ['dba']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://github.com/blambeau/dbagile"
  s.add_dependency('sbyc', '>= 0.1.4')
  s.add_dependency('sequel', '>= 0.3.8')
  s.add_dependency('highline', '>= 1.5.2')
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
