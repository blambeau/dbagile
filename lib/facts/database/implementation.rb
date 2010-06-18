module Facts
  class Database
    module Implementation
      
      ### All section is private
      private
      
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
      end
      
      # Removes all facts
      def remove_all_facts(name, attributes, transaction = connection)
        transaction.delete(name, attributes)
      end
      
      # Retrieves a given fact
      def retrieve_fact(name, projection_key, keys, default = nil, transaction = connection, &block)
        tuple = transaction.dataset(name, projection_key).to_a
        if tuple.size > 1
          raise "Projection #{projection_key.inspect} is not a key for facts collection #{name}\n"
        end
        if tuple = tuple.first
          build_fact(tuple, keys, default || block)
        else
          build_default_fact(keys, default || block)
        end
      end
      
      # Builds a fact from a tuple
      def build_fact(tuple, keys, default)
        if keys.kind_of?(Symbol)
          build_fact(tuple, [ keys ], default)[keys]
        else
          fact = {}
          keys.each{|k| 
            value = tuple[k]
            value = default[k] if value.nil? && !default.nil?
            fact[k] = value
          }
          fact
        end
      end
      
      # Builds a default fact
      def build_default_fact(keys, default)
        return nil if default.nil?
        if keys.kind_of?(Symbol)
          build_default_fact([ keys ])[keys]
        else
          fact = {}
          keys.each{|k| fact[k] = default[k]}
          fact
        end
      end
      
    end # module Implementation
  end # module Database
end # module Facts