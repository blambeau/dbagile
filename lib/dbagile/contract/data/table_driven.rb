module DbAgile
  module Contract
    module Data
      #
      # Table driven methods of the contract
      #
      module TableDriven
      
        #
        # Returns a dataset object for a given table (if a Symbol is given) or query 
        # (if a String is given). 
        #
        # As DbAgile aims at helping to manage SQL database access with respect to their
        # schema, it does not specifies a detailed contract about the object returned here,
        # which is related to queries, not schema modification. The kind of returned object
        # is therefore left open to adapter specfic implementations.
        #
        # We expect (mainly for tests) the following about datasets:
        # - count: returns the number of records inside the dataset
        # - to_a: returns an array of hashes representing records
        #
        # @param [Symbol | String] table_or_query name of a table or query string
        # @param [Hash | nil] a tuple projection for query restriction
        # @return [...] a dataset object with query (execution result)
        #
        # @pre [table_or_query] all referenced tables must exist
        #
        def dataset(table_or_query, proj = nil)
          Kernel.raise NotImplementedError
        end
      
        # 
        # Checks if a (sub)-tuple exists inside a table.
        #
        # @param [Symbol | String] table_or_query name of a table or query string
        # @param [Hash] subtuple a tuple or tuple projection for the result
        # @return true if the projection of the query result on subtuple's heading contains
        #         the subtuple itself, false otherwise.
        #
        # @pre [table_or_query] all referenced tables must exist
        #
        def exists?(table_or_query, subtuple = {})
          Kernel.raise NotImplementedError
        end
      
      end # module TableDriven
    end # module Data
  end # module Contract
end # module DbAgile
