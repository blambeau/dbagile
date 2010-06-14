module DbAgile
  class MemoryAdapter < Adapter
    class Table
      include Enumerable
      include DbAgile::Adapter::Tools

      # Table's heading
      attr_accessor :heading
      
      # Table's tuples
      attr_accessor :tuples

      # Table's keys
      attr_accessor :keys
      
      # Creates a table instance with some tuples
      def initialize(heading, tuples = [])
        @heading = heading
        @keys = []
        @tuples = tuples
      end
      
      # Yiels the block with each tuple
      def each(&block)
        tuples.each {|tuple|
          (heading.keys-tuple.keys).each{|k| tuple[k] = nil}
          yield tuple
        }
      end
      
      # Adds a key to this table
      def add_key(columns)
        keys << columns
        columns
      end
      
      # Returns columns names
      def column_names(sort = false)
        sort ?  heading.keys.sort{|k1, k2| k1.to_s <=> k2.to_s} : heading.keys
      end
      
      # Adds some columns
      def add_columns(columns)
        heading.merge!(columns)
      end
      
      # Checks that key is not violated if we insert a given tuple
      def check_key(tuple, key)
        proj = tuple_project(tuple, key)
        found = tuples.find{|t|
          tuple_project(t, key) == proj
        }
        found.nil?
      end
      
      # Inserts a tuple inside the table
      def insert(tuple)
        raise DbAgile::Adapter::KeyViolationError if keys.find{|key| !check_key(tuple, key)}
        tuples << tuple
        tuple
      end
      
      # Truncates the table
      def truncate!
        @tuples = []
      end
      
      # Counts the number of tuples
      def count
        tuples.size
      end
      
      # Returns an array of tuples
      def to_a
        self.collect{|t| t}
      end
      
    end # class Table
  end # class MemoryAdapter
end # module DbAgile