Gem::Specification.new do |s|
  s.name = 'dbagile'
  s.version = "0.0.2"
  s.summary = "DbAgile - Agile Interface on top of SQL Databases"
  s.description = %{Agile Interface on top of SQL Databases}
  s.files = Dir['lib/**/*'] + Dir['test/**/*']
  s.require_path = 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.textile", "LICENCE.textile"]
  s.rdoc_options << '--title' << 'DbAgile - Agile Interface on top of SQL Databases' <<
                    '--main' << 'README.textile' <<
                    '--line-numbers'  
  s.bindir = "bin"
  s.executables = ['dba']
  s.author = "Bernard Lambeau"
  s.email = "blambeau@gmail.com"
  s.homepage = "http://github.com/blambeau/dbagile"
  s.add_development_dependency("rake", "~> 0.8.7")
  s.add_development_dependency("bundler", "~> 1.0")
  s.add_development_dependency("rspec", "~> 2.4.0")
  s.add_development_dependency("yard", "~> 0.6.4")
  s.add_development_dependency("bluecloth", "~> 2.0.9")
  s.add_development_dependency("sqlite3")
  s.add_development_dependency("pg")
  s.add_dependency('fastercsv')
  s.add_dependency('json')
  s.add_dependency('builder')
  s.add_dependency('rack')
  s.add_dependency('sbyc', '>= 0.1.4')
  s.add_dependency('sequel', '>= 0.3.8')
  s.add_dependency('highline', '>= 1.5.2')
end
