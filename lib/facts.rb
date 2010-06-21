require 'dbagile'
module Facts
  
  # Version of Facts
  VERSION = "0.0.1".freeze
  
  # Connects to a Facts database
  def self.connect(uri)
    conn = DbAgile::config{
      plug DbAgile::Plugin::AgileKeys[:candidate => /[#]$/]
      plug DbAgile::Plugin::AgileTable
      plug DbAgile::Plugin::Defaults[:fact_created_at => DbAgile::Plugin::Touch::now]
      plug DbAgile::Plugin::Touch[:fact_updated_at => DbAgile::Plugin::Touch::now]
    }.connect(uri)
    Facts::Database.new(conn)
  end
  
end # module Facts
require 'facts/database'
require 'facts/restful'