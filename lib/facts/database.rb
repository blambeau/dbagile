require 'facts/database/implementation'
module Facts
  class Database
    include Facts::Database::Implementation
    
    # Underlying dbagile connection
    attr_reader :connection
    
    # Creates a Facts database on top of a DbAgile connection
    def initialize(connection)
      @connection = connection
    end
    
    # Executes the block inside a transaction
    def transaction 
      yield(self)
    end
    
    # Asserts a fact inside the database
    def fact!(name, attributes)
      connection.transaction do |t|
        ensure_structural_fact(name, attributes, t)
        ensure_data_fact(name, attributes, t)
      end
    end
    
    # Removes any fact named _name_ whose projection over
    # _attributes_ keys is equal to attributes.
    def nofact!(name, attributes)
      if has_structural_fact?(name, attributes)
        connection.transaction do |t|
          remove_all_facts(name, attributes, t)
        end
      end
    end
    
    # Checks if a fact exist in the database
    def fact?(name, projection)
      has_structural_fact?(name, projection) && has_data_fact?(name, projection)
    end
    
    # Retrieve a fact from the database
    def fact(name, projection_with_key, keys, default = nil)
      if has_structural_fact?(name, projection_with_key)
        retrieve_fact(name, projection_with_key, keys, default)
      else
        default
      end
    end

    private :connection    
  end # class Database
end # module Facts