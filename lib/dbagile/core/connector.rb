module DbAgile
  module Core
    class Connector
      
      # Main chain
      attr_reader :main_chain
      
      # Chain for each table
      attr_reader :table_chains
      
      # Creates an empty connector
      def initialize(main = nil, tables = nil, connected = false)
        @main_chain = (main || DbAgile::Core::Chain.new)
        @table_chains = (tables || Hash.new)
        @connected = connected
      end
      
      # Is it a connected connector?
      def connected?
        @connected
      end
      
      # Plugs some components
      def plug(*args)
        tables = []
        tables << args.shift while args[0].kind_of?(Symbol)
        if tables.empty?
          main_chain.plug(*args)
        else
          tables.each{|t| 
            unless table_chains.key?(t)
              if connected?
                table_chains[t] = DbAgile::Core::Chain[main_chain]
              else
                table_chains[t] = DbAgile::Core::Chain.new 
              end
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
        raise "Connector already connected" if connected?
        main = main_chain.connect(last)
        tables = {}
        table_chains.each_pair{|name, chain| 
          tables[name] = chain.connect(main)
        }
        Connector.new(main, tables, true)
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
  end # module Core
end # module DbAgile