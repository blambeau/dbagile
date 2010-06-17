module DbAgile
  class Facts
    include DbAgile::Adapter::Tools
    
    # Connects a facts database
    def self.connect(uri, options = {}, recognizer = DbAgile::Facts::Recognizer.new)
      config = DbAgile::config{
        plug AgileKeys, AgileTable
      }
      connection = config.connect(uri, options)
      Facts.new(connection, recognizer)
    end
    
    # The fact recognizer
    attr_reader :recognizer
    
    # The AgileDb connection
    attr_reader :connection
    
    # Creates a Facts database instance
    def initialize(connection, recognizer)
      @connection, @recognizer = connection, recognizer
    end
    
    # Asserts a fact inside the database
    def fact!(name, fact = nil)
      if name.kind_of?(Hash) and fact.nil?
        fact!(recognizer.fact_name(name), name)
      else
        key_attributes = recognizer.extract_key(fact)
        fact_key = tuple_key(fact, [ key_attributes ])
        connection.transaction do |t|
          if t.has_table?(name) && t.exists?(name, fact_key)
            t.update(name, fact_key, fact)
          else
            inserted = t.insert(name, fact)
            fact_key = tuple_key(inserted, [ key_attributes ])
          end
        end
        fact_key
      end
    end
    
  end # class Facts
end # module DbAgile
require 'dbagile/facts/recognizer'