require "rubygems"
require "rake/rdoctask"
require "rake/testtask"
require 'spec/rake/spectask'
require "rake/gempackagetask"
require "yard"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "flexidb.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:test]

desc "Run all rspec test"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.ruby_opts = ['-I.']
  t.spec_files = FileList['spec/test_all.rb']
end

desc "Launches all tests"
task :test => [:spec]

YARD::Rake::YardocTask.new do |t|
  YARD::Tags::Library.define_tag "Precondition", :pre
  YARD::Tags::Library.define_tag "Postcondition", :post
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', 'doc/api', '-', "README.textile", "LICENCE.textile", "CHANGELOG.textile"]
end

gemspec = Gem::Specification.new do |s|
  s.name = 'flexidb'
  s.version = version
  s.summary = "FlexiDB - Flexible Interface on top of SQL Databases"
  s.description = %{Flexible Interface on top of SQL Databases}
  s.files = Dir['lib/**/*'] + Dir['test/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENCE.textile"]
  s.rdoc_options << '--title' << 'FlexiDB - Flexible Interface on top of SQL Databases' <<
                    '--main' << 'README.textile' <<
                    '--line-numbers'  
  s.bindir = "bin"
  s.executables = []
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://github.com/blambeau/flexidb"
end
Rake::GemPackageTask.new(gemspec) do |pkg|
	pkg.need_tar = true
end
