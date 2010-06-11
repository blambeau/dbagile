require 'logger'
module DbAgile
  class Plugin
    class Trace < Plugin
      
      # Returns default options
      def default_options
        {:logger => Logger.new(STDOUT)}
      end
      
      # Returns the logger instance
      def logger
        @logger ||= options[:logger]
      end
      
      ### ABOUT CONNECTIONS ########################################################
      
      # Disconnect the adapter and frees all resources.
      def disconnect
        logger.info("Disconnecting: #{(x = super).inspect}")
        x
      end
    
      ### ABOUT QUERIES ############################################################
      
      # Returns a dataset object for a given table (if a Symbol is given) or query 
      # (if a String is given). 
      def dataset(table_or_query)
        logger.debug("Dataset request '#{table_or_query}': #{(x = super).inspect}")
        x
      end
      
      ### SCHEMA UPDATES ###########################################################
      
      # Creates a table with some columns. 
      def create_table(table_name, columns)
        logger.info("Creating table #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Adds some columns to a table
      def add_columns(table_name, columns)
        logger.info("Adding columns #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      # 
      # Make columns be a candidate key for the table.
      #
      # @param [Symbol] table_name the name of a table
      # @param [Array<Symbol>] columns column names
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database contains a table with that name
      # @pre the table contains all the columns
      # @post the table has gained the candidate key
      #
      def key(table_name, columns)
        logger.info("Creating key #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      ### DATA UPDATES #############################################################
      
      #
      # Inserts a tuple inside a given table
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] record a record as a hash (column_name -> value)
      # @return [Hash] inserted record as a hash
      #
      # @pre the database contains a table with that name
      # @pre the record is valid for the table
      # @post the record has been inserted.
      #
      def insert(table_name, record)
        logger.debug("Inserting #{table_name}::#{record.inspect} : #{(x = super).inspect}")
        x
      end
      
      #
      # Send SQL directly to the database SQL server.
      #
      # Returned result is left opened to adapters.
      #
      # @param [String] sql a SQL query
      # @return [...] adapter defined
      #
      def direct_sql(sql)
        logger.debug("SQL direct #{sql}: #{(x = super).inspect}")
        x
      end
      
    end # class Trace
  end # class Plugin
end # module DbAgile