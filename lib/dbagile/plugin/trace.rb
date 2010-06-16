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
      def create_table(transaction, table_name, columns)
        logger.info("Creating table #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Adds some columns to a table
      def add_columns(transaction, table_name, columns)
        logger.info("Adding columns #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Makes columns be a candidate key for the table.
      def key!(transaction, table_name, columns)
        logger.info("Creating key #{table_name}::#{columns.inspect} : #{(x = super).inspect}")
        x
      end
      
      ### DATA UPDATES #############################################################
      
      # Inserts a tuple inside a given table
      def insert(transaction, table_name, record)
        logger.debug("Inserting #{table_name}::#{record.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Updates all tuples whose projection equal _proj_ with values given by _update_ 
      # inside a given table
      def update(transaction, table_name, proj, update)
        logger.debug("Updating #{table_name}::#{update.inspect} where #{proj.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Deletes all tuples whose projection equal _proj_ from a given table
      def delete(transaction, table_name, proj)
        logger.debug("Deleting #{table_name} where #{proj.inspect} : #{(x = super).inspect}")
        x
      end
      
      # Sends SQL directly to the database SQL server.
      def direct_sql(transaction, sql)
        logger.debug("SQL direct #{sql}: #{(x = super).inspect}")
        x
      end
      
    end # class Trace
  end # class Plugin
end # module DbAgile