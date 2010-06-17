module DbAgile
  class Facts
    include DbAgile::Adapter::Tools
    
    # Capture
    CAPTURE = Object.new
    
    # Returns 
    def self._
      CAPTURE
    end
    
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
    
    # Returns a fact by name and key
    def fact(name, key, default = nil, transaction = connection)
      if transaction.has_table?(name)
        tuple = transaction.dataset(name, key).to_a
        case tuple.size
          when 0
            default
          when 1
            tuple.first
          else
            raise "Key #{key.inspect} is not a key for facts #{name}"
        end
      else
        default
      end 
    end
    
    # Resolves fact captures
    def resolve_captures(name, fact, transaction)
      fact.each_pair do |key, value|
        next unless CAPTURE == value
        seq_key = {:'fact#' => name.to_s, :'attr#' => key.to_s}
        seq_next = fact(:facts_sequences, seq_key, {:value => 0})[:value]
        __fact!(:facts_sequences, seq_key.merge(:value => seq_next + 1), transaction)
        fact[key] = seq_next
      end
      fact
    end
    
    # Asserts a fact inside the database
    def fact!(name, fact = nil)
      if name.kind_of?(Hash) and fact.nil?
        fact!(recognizer.fact_name(name), name)
      else
        connection.transaction do |t|
          __fact!(name, resolve_captures(name, fact.dup, t), t)
        end
      end
    end
    
    # Internal implementation of fact!
    def __fact!(name, fact, transaction)
      key_attributes = recognizer.extract_key(fact)
      fact_key = tuple_key(fact, [ key_attributes ])
      if transaction.has_table?(name) && transaction.exists?(name, fact_key)
        transaction.update(name, fact_key, fact)
      else
        inserted = transaction.insert(name, fact)
        fact_key = tuple_key(inserted, [ key_attributes ])
      end
      fact_key
    end
    
  end # class Facts
end # module DbAgile
require 'dbagile/facts/recognizer'