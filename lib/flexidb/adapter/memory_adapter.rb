module FlexiDB
  #
  # Implements the Adapter contract using memory tables.
  #
  class MemoryAdapter < Adapter
    
    class Table
      include Enumerable
      attr_accessor :heading
      attr_accessor :tuples
      def initialize(heading, tuples = [])
        @heading = heading
        @tuples = []
      end
      def each(&block)
        tuples.each {|tuple|
          (heading.keys-tuple.keys).each{|k| tuple[k] = nil}
          yield tuple
        }
      end
      def column_names(sort = false)
        sort ?  heading.keys.sort{|k1, k2| k1.to_s <=> k2.to_s} : heading.keys
      end
      def add_columns(columns)
        heading.merge!(columns)
      end
      def insert(tuple)
        tuples << tuple
        tuple
      end
      def count
        tuples.size
      end
      def to_a
        self.collect{|t| t}
      end
    end
    
    # Table hash (name -> array of hash tuples)
    attr_reader :tables
    
    # Creates an adapter instance
    def initialize
      @tables = {}
    end
    
    # Returns a Dataset object for a given table
    def dataset(table)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table]
    end
    
    # Returns true if a table exists, false otherwise
    def has_table?(name)
      tables.key?(name)
    end
    
    # Creates a table with some attributes.
    def create_table(name, columns)
      raise ArgumentError, "Table #{name} already exists" if has_table?(name)
      tables[name] = Table.new(columns)
    end
    
    # Returns the list of column names for a given table
    def column_names(table, sort = false)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].column_names(sort)
    end
    
    # Creates a table with some attributes.
    def add_columns(table, columns)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].add_columns(columns)
    end
    
    # Inserts a tuple inside a given table
    def insert(table, tuple)
      raise ArgumentError, "No such table #{table}" unless has_table?(table)
      tables[table].insert(tuple)
    end
    
    # Send SQL directly to the database SQL server
    def direct_sql(sql)
      raise NotImplementedError
    end

  end # class SequelAdapter
end # module FlexiDB