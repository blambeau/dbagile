module DbAgile
  class SequelAdapter < Adapter
    module Schema
      class Expander
        
        # Connection on which this expander executes
        attr_reader :conn
  
        # Buffer for outputting SQL
        attr_reader :sql_buffer
  
        # Status of each object
        attr_reader :status
  
        # Helper for each table
        attr_reader :helpers
  
        # Creates an algorithm instance
        def initialize(conn)
          @conn = conn
        end
  
        ############################################################################
        ### Helpers and schema info they need
        ############################################################################
        
        # Creates an helper for a relation variable and yield the block
        def with_helper(rv)
          if h = helpers[rv]
            yield(h)
          else
            h = helpers[rv] = TableExpandHelper.new(rv.name, self, conn)
            yield(h)
            h.flush(sql_buffer)
            helpers.delete(rv)
          end
        end
  
        # Checks if table already exists
        def table_exists?(name)
          @created_tables.key?(name) or conn.table_exists?(name)
        end
  
        # Asserts that a table exists
        def table_exists!(name)
          @created_tables[name] = true
        end
  
        ############################################################################
        ### Public interface
        ############################################################################
        
        # Run algorithm on the schema
        def run(schema, sql_buffer = "")
          @sql_buffer = sql_buffer
          @status  = {}
          @helpers = {}
          @created_tables = {}
          
          # Take all objects and mark them as :to_ensure
          all_objects = schema.collect{|o, parent| o}
          all_objects.each{|obj| status[obj] = :to_ensure}
          
          # Make the job now!
          ensure_objects(all_objects)
          
          # clean
          @sql_buffer = nil
          @status  = {}
          @helpers = {}
          @created_tables = {}
          
          sql_buffer
        end

        ############################################################################
        ### Private algorithm
        ############################################################################

        # Ensures existence of a list of schema objects.
        def ensure_objects(schema_objects)
          schema_objects.each do |object| 
            case status[object]
              when :to_ensure
                ensure_object(object)
              when :ensured
                # part has been ensured, nothing do to
              when :pending
                # cycles are not supported so far
                raise "Already pending on #{object}"
            end
          end
        end
        
        # Ensures existence of a single schema object
        def ensure_object(object)
          parent = object.parent

          if status[parent] == :to_ensure
            #
            # Delegate to parent if it needs to be ensured itself
            #
            # Making this helps issuing a single CREATE TABLE instead of 
            # many ALTER TABLE statements, which are not always supported
            # by adapters.
            #
            ensure_object(parent)
            
          else
            # Mark the object as being currently created
            status[object] = :pending
      
            # ensure dependencies
            ensure_objects(object.outside_dependencies)
      
            # ensure itself and recurse on children
            ensure_call = :"ensure_#{object.builder_handler}"
            if object.composite?
              # ensure composite objects
              if self.respond_to?(ensure_call)
                self.send(ensure_call, object){ ensure_objects(object.parts) }
              else
                ensure_objects(object.parts)
              end
            else
              # ensure part objects
              self.send(ensure_call, object)
            end

            # mark object as ensured!
            status[object] = :ensured
          end
        end
  
        ### Composites
  
        def ensure_relvar_xxx(xxx)
          with_helper(rv = xxx.relation_variable){|helper| yield}
        end
        alias :ensure_relvar :ensure_relvar_xxx
        alias :ensure_heading :ensure_relvar_xxx
  
        ### Parts

        def ensure_attribute(attribute)
          with_helper(rv = attribute.relation_variable){|helper|
            helper.attribute(attribute)
          }
        end

        def ensure_candidate_key(ckey)
          with_helper(rv = ckey.relation_variable){|helper|
            helper.candidate_key(ckey)
          }
        end

        def ensure_foreign_key(fkey)
          with_helper(rv = fkey.relation_variable){|helper|
            helper.foreign_key(fkey)
          }
        end

        def ensure_index(index)
          with_helper(rv = index.indexed_relvar){|helper|
            helper.index(index)
          }
        end

      end # class Expander
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
