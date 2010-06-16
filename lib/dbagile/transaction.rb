module DbAgile
  class Transaction
    
    ### VARS AND INITIALIZE ########################################################
    
    # Underlying database
    attr_reader :database
    
    # Creates a Transaction instance
    def initialize(database)
      @database = database
    end
    
    ### ABOUT TRANSACTION MANAGEMENT ###############################################
    
    # Commits the transaction
    def commit
    end
    
    # Rollbacks the transaction
    def rollback
    end
    
    ### ABOUT QUERIES ##############################################################
    
    # @see Database#dataset
    def dataset(table_or_query, proj = nil)
      database.dataset(table_or_query, proj)
    end
    
    # @see Database#exists?
    def exists?(table_or_query, subtuple = {})
      database.exists?(table_or_query, subtuple)
    end
    
    ### SCHEMA QUERIES #############################################################
    
    # @see Database#has_table?
    def has_table?(table_name)
      database.has_table?(table_name)
    end
    
    # @see Database#has_column?
    def has_column?(table_name, column_name)
      database.has_column?(table_name, column_name)
    end
    
    # @see Database#column_names(table_name, sort)
    def column_names(table_name, sort = false)
      database.column_names(table_name, sort)
    end
    
    # @see Database#keys
    def keys(table_name)
      database.keys(table_name)
    end
    
    ### SCHEMA UPDATES #############################################################
    
    # Delegated to chain
    def create_table(table_name, columns)
      database.find_delegate(table_name).create_table(self, table_name, columns)
    end
    
    # Delegated to chain
    def add_columns(table_name, columns)
      database.find_delegate(table_name).add_columns(self, table_name, columns)
    end
    
    # Delegated to chain
    def key!(table_name, columns)
      database.find_delegate(table_name).key!(self, table_name, columns)
    end
    
    ### DATA UPDATES ###############################################################
    
    # Delegated to chain
    def insert(table_name, record)
      database.find_delegate(table_name).insert(self, table_name, record)
    end
    
    # Delegated to chain
    def update(table_name, proj, update)
      database.find_delegate(table_name).update(self, table_name, proj, update)
    end
    
    # Delegated to chain
    def delete(table_name, proj)
      database.find_delegate(table_name).delete(self, table_name, proj)
    end
    
    # Delegated to chain
    def direct_sql(sql)
      database.main_delegate.direct_sql(self, sql)
    end
    
  end # class Transaction
end # module DbAgile