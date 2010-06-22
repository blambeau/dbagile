module Facts
  class Database
    module Implementation
      
      # Returns relational utils
      def relutils
        unless @relutils
          @relutils = Object.new
          @relutils.extend(::DbAgile::Adapter::Tools)
        end
        @relutils
      end
      
      # Checks if db structure is ready pro a given fact
      def has_structural_fact?(name, projection, transaction = connection)
        return false unless transaction.has_table?(name) 
        fact_columns = projection.keys
        table_columns = transaction.column_names(name)
        (fact_columns - table_columns).empty?
      end
      
      # Ensures that database structure is ready for a given fact
      def ensure_structural_fact(name, attributes, transaction = connection)
        heading = relutils.tuple_heading(attributes)
        if transaction.has_table?(name)
          existing_columns = transaction.column_names(name)
          missing_columns = heading.delete_if{|k,v| existing_columns.include?(k)}
          transaction.add_columns(name, missing_columns) unless missing_columns.empty?
        else
          transaction.create_table(name, heading)
        end
      end
      
      # Checks if fact exists inside the database
      def has_data_fact?(name, projection, transaction = connection)
        transaction.exists?(name, projection)
      end
      
      # Ensures data of a fact
      def ensure_data_fact(name, attributes, transaction = connection)
        tuple_key = relutils.tuple_key(attributes, transaction.keys(name))
        if transaction.exists?(name, tuple_key)
          transaction.update(name, tuple_key, attributes)
        else
          transaction.insert(name, attributes)
        end
        retrieve_fact(name, tuple_key, nil)
      end
      
      # Removes all facts
      def remove_all_facts(name, attributes, transaction = connection)
        transaction.delete(name, attributes)
      end
      
      # Retrieves a given fact
      def retrieve_fact(name, projection_key, keys, default = nil, transaction = connection, &block)
        projection_key = nil if projection_key.nil? or projection_key.empty?
        tuple = transaction.dataset(name, projection_key).to_a
        if tuple.size > 1
          raise "Projection #{projection_key.inspect} is not a key for facts collection #{name}\n"
        end
        if tuple = tuple.first
          build_fact(tuple, keys, default, &block)
        else
          build_default_fact(keys, default, &block)
        end
      end
      
      # Retrieves a given fact
      def retrieve_facts(name, projection, keys, default = nil, transaction = connection, &block)
        projection = nil if projection.nil? or projection.empty?
        tuples = transaction.dataset(name, projection).to_a
        tuples = tuples.collect{|t| build_fact(t, keys, default, &block)}
        tuples
      end
      
      # Builds a fact from a tuple
      def build_fact(tuple, keys, default = nil, &block)
        default = default.nil? ? block : default
        build_default_fact(keys.nil? ? tuple.keys : keys){|k|
          value = tuple[k]
          value = get_default_value(k, default) if value.nil?
          value
        }
      end
      
      # Builds a default fact
      def build_default_fact(keys, default = nil, &block)
        default = default.nil? ? block : default
        if keys.kind_of?(Symbol)
          build_default_fact([ keys ], default)[keys]
        else
          return {} if keys.nil? or keys.empty?
          fact = {}
          keys.each{|k| 
            value = get_default_value(k, default)
            fact[k] = value unless value.nil?
          }
          fact
        end
      end
      
      # Returns a default value given a key, a default and a block
      def get_default_value(key, default)
        case default
          when Hash, Proc
            default[key]
          else
            default
        end
      end
      
    end # module Implementation
  end # module Database
end # module Facts