module DbAgile
  class SequelAdapter < Adapter
    module Data
      module TableDriven

        # @see DbAgile::Contract::Data::TableDriven#dataset
        def dataset(table, proj = nil)
          result = case table
            when Symbol
              has_table!(table)
              proj.nil? ? db[table] : db[table].where(proj)
            else
              proj.nil? ? db[table] : db[table].where(proj)
          end
          result.extend(::DbAgile::Contract::Data::Dataset)
          result
        end
      
        # @see DbAgile::Contract::Data::TableDriven#exists?
        def exists?(table_or_query, subtuple = {})
          if subtuple.nil? or subtuple.empty?
            !dataset(table_or_query).empty?
          else
            !dataset(table_or_query).where(subtuple).empty?
          end
        end
    
      end # module TableDriven
    end # module Data
  end # class SequelAdapter
end # module DbAgile
