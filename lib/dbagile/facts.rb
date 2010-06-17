require 'dbagile/facts/recognizer'
require 'dbagile/facts/errors'
require 'dbagile/facts/configuration'
module DbAgile
  class Facts
    include DbAgile::Facts::Configuration
    include DbAgile::Adapter::Tools
    
    # Connects a facts database
    def self.connect(uri, options = {})
      config = DbAgile::config{
        plug AgileKeys, AgileTable
      }
      connection = config.connect(uri, options)
      Facts.new(connection)
    end
    
    # The AgileDb connection
    attr_reader :connection
    
    # Creates a Facts database instance
    def initialize(connection)
      @connection = connection
      default_configuration!
    end
    
    # Starts a transaction
    def transaction
      yield(self)
    end
    
    ### Implementation of fact! ####################################################
    
    # Asserts a fact inside the database
    def fact!(*args)
      name, fact = recognizer.normalize_fact(*args)
      connection.transaction do |t|
        __fact!(name, resolve_captures(name, fact, t), t)
      end
    end
    
    # Internal implementation of fact!
    def __fact!(name, fact, transaction)
      fact_key = recognizer.fact_key(name, fact)
      if __fact?(name, fact_key, transaction)
        transaction.update(name, fact_key, fact)
      else
        inserted = transaction.insert(name, fact)
        fact_key = recognizer.fact_key(name, inserted)
      end
      fact_key
    end
    
    ### Implementation of fact? ####################################################
    
    # Checks if a fact exists inside the database
    def fact?(*args)
      name, fact = recognizer.normalize_fact(*args)
      __fact?(name, fact, connection)
    end
    
    # Internal implementation of fact?
    def __fact?(name, fact, transaction = connection)
      transaction.has_table?(name) && transaction.exists?(name, fact)
    end

    ### Implementation of fact #####################################################

    # Returns a fact or a default one
    def fact(*args)
      if args[0].kind_of?(Symbol)
        name, fact = args.shift, args.shift
        name, fact = recognizer.normalize_fact(name, fact)
      else
        name, fact = recognizer.normalize_fact(args.shift)
      end
      __fact(name, fact, args.first)
    end

    # Internal implementation of fact
    def __fact(name, fact_key, default = nil, transaction = connection)
      if transaction.has_table?(name)
        tuple = transaction.dataset(name, fact_key).to_a
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
    
    ### Other tools ################################################################

    # Resolves fact captures
    def resolve_captures(name, fact, transaction)
      # fact.each_pair do |key, value|
      #   next unless CAPTURE == value
      #   seq_key = {:'fact#' => name.to_s, :'attr#' => key.to_s}
      #   seq_next = fact(:facts_sequences, seq_key, {:value => 0})[:value]
      #   __fact!(:facts_sequences, seq_key.merge(:value => seq_next + 1), transaction)
      #   fact[key] = seq_next
      # end
      fact
    end
    
    private :__fact!
    private :__fact?
    private :__fact
  end # class Facts
end # module DbAgile
