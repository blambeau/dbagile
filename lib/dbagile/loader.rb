require 'dbagile/robustness'

# standard library
DbAgile::Robustness::has_stdlib! 'time'
DbAgile::Robustness::has_stdlib! 'fileutils'
DbAgile::Robustness::has_stdlib! 'pathname'
DbAgile::Robustness::has_stdlib! 'tempfile'
DbAgile::Robustness::has_stdlib! 'date'
DbAgile::Robustness::has_stdlib! 'yaml'
DbAgile::Robustness::has_stdlib! 'readline'
DbAgile::Robustness::has_stdlib! 'stringio'

# external gems
DbAgile::Robustness::has_gem! "sbyc", ">= 0.1.4"
DbAgile::Robustness::has_gem! "sequel", ">= 3.8.0"
DbAgile::Robustness::has_gem! 'highline', '>= 1.5.2'
