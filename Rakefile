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

# Default task is spec
task :default => [:spec]

# Creates the fixtures
desc "Creates physical SQL test databases"
task :physical_fixtures do
  require 'readline'
  puts "#################################################################################"
  puts "ATTENTION: This task will create physical test databases on your computer"
  puts "           A password will probably be asked as this task relies on 'sudo'."
  puts "           Please provide the root password"
  puts "#################################################################################"
  Readline.readline("Press enter to start")
  puts "Creating the physical postgresql database ..."
  puts `sudo su postgres -c 'dropdb dbagile_test'`
  puts `sudo su postgres -c 'dropuser dbagile'`
  puts `sudo su postgres -c 'createuser --no-superuser --no-createrole --createdb dbagile'`
  puts `sudo su postgres -c 'createdb --encoding=utf8 --owner=dbagile dbagile_test'`
  puts 
  puts "#################################################################################"
  puts "Done."
  puts "Please run 'rake fixtures'"
  puts "#################################################################################"
end

desc "Creates test fixture databases"
task :fixtures do
  load(File.expand_path('../test/fixtures/build.rb', __FILE__))
end

# About spec tests
desc "Run all rspec test"
Spec::Rake::SpecTask.new do |t|
  t.ruby_opts = ['-I.']
  t.spec_files = FileList['test/spec/test_all.rb', 'test/adapters.spec', 'test/commands.spec']
end

# About yard documentation
YARD::Rake::YardocTask.new do |t|
  YARD::Tags::Library.define_tag "Precondition", :pre
  YARD::Tags::Library.define_tag "Postcondition", :post
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', 'doc/api', '-', "README.textile", "COMMAND_LINE.textile", "LICENCE.textile", "CHANGELOG.textile"]
end

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
  s.add_dependency('sbyc', '>= 0.1.2')
  s.add_dependency('sequel', '>= 0.3.8')
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
