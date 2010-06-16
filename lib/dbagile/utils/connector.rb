module DbAgile
  module Utils
    class Connector
      
      # Main chain
      attr_reader :main_chain
      
      # Chain for each table
      attr_reader :table_chains
      
      # Creates an empty connector
      def initialize(main = nil, tables = nil)
        @main_chain = (main || DbAgile::Utils::Chain.new)
        @table_chains = (tables || Hash.new)
      end
      
      # Plugs some components into the configuration
      def plug(*args)
        tables = []
        tables << args.shift while args[0].kind_of?(Symbol)
        if tables.empty?
          main_chain.plug(*args)
        else
          tables.each{|t| 
            unless table_chains.key?(t)
              table_chains[t] = DbAgile::Utils::Chain.new 
            end
            table_chains[t].plug(*args)
          }
        end
      end
      
      # Returns the main delegate
      def main_delegate
        main_chain
      end
      
      # Finds the delegate to use for a given name
      def find_delegate(name)
        table_chains[name] || main_chain
      end
      
      # Connect with a last element
      def connect(last)
        main = main_chain.connect(last)
        tables = {}
        table_chains.each_pair{|name, chain| tables[name] = chain.connect(main)}
        Connector.new(main, tables)
      end
      
      # Returns an inspection string
      def inspect
        buffer = "main: #{main_chain.inspect}\n"
        table_chains.each_pair{|name, chain|
          buffer << "#{name}: #{chain.inspect}\n"  
        }
        buffer
      end
      
    end # class Connector
  end # module Utils
end # module DbAgile