module DbAgile
  class SequelAdapter < Adapter
    module Schema
      class Stager
        
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
        ### Schema info helpers need
        ############################################################################
        
        # Checks if table already exists
        def relvar_exists?(rv)
          (rv.annotation == :alter) or (status[rv] == :expanded)
        end
  
        # Asserts that a table exists
        def relvar_exists!(rv)
          status[rv] = :expanded
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
          all_objects.each{|obj| status[obj] = obj.annotation}
          
          # Collapse first
          collapse_objects(all_objects.select{|obj| status[obj] == :drop})
          
          # Expand then
          expand_objects(all_objects.select{|obj| status[obj] == :create})
          
          # clean
          @sql_buffer = nil
          @status  = {}
          @helpers = {}
          @created_tables = {}
          
          sql_buffer
        end
        
        ############################################################################
        ### Collapse algorithms (for drop)
        ############################################################################

        # Creates an helper for a relation variable and yield the block
        def with_collapse_helper(rv)
          if h = helpers[rv]
            yield(h)
          else
            h = helpers[rv] = TableCollapseHelper.new(rv, self, conn)
            yield(h)
            h.flush(sql_buffer)
            helpers.delete(rv)
          end
        end
  
        # Ensures inexistence of a list of schema objects
        def collapse_objects(schema_objects)
          schema_objects.each do |object|
            case s = status[object]
              when :drop, :alter
                collapse_object(object)
              when :same, :collapsed
                # nothing to do
              else
                msg = "Unexpected status #{s} for #{object} for schema collapsing"
                raise AssumptionFailedError, msg
            end
          end
        end
        
        # Ensures inexistence of a single schema object
        def collapse_object(object)
          parent = object.parent
          
          case status[parent]
            when :dropped
              # nothing do do, parent has certainly removed me
            when :drop
              #
              # Delegate to parent if it needs to be collapsed itself
              #
              # Making this helps issuing a single DROP TABLE and avoiding 
              # many ALTER TABLE that will eventually fail (the last column)
              #
              collapse_object(parent)
            else
              status[object] = :pending
              
              collapse_call = :"collapse_#{object.builder_handler}"
              self.send(collapse_call, object)
              
              status[object] = :dropped
          end
        end

        # Collapses a relation variable
        def collapse_relvar(relvar)
          with_collapse_helper(relvar){|h| h.relvar(relvar)}
        end

        # Collapses a candidate key
        def collapse_candidate_key(ckey)
          with_collapse_helper(ckey.relation_variable){|h| h.candidate_key(ckey)}
        end

        # Collapses a foreign key
        def collapse_foreign_key(fkey)
          with_collapse_helper(fkey.relation_variable){|h| h.foreign_key(ckey)}
        end

        # Collapses an attribute
        def collapse_attribute(attribute)
          with_collapse_helper(attribute.relation_variable){|h| h.attribute(attribute)}
        end

        # Collapses an index
        def collapse_index(index)
          with_collapse_helper(index.indexed_relvar){|h| h.index(index)}
        end

        ############################################################################
        ### Expand algorithms (for alter/create)
        ############################################################################

        # Creates an helper for a relation variable and yield the block
        def with_expand_helper(rv)
          if h = helpers[rv]
            yield(h)
          else
            h = helpers[rv] = TableExpandHelper.new(rv, self, conn)
            yield(h)
            h.flush(sql_buffer)
            helpers.delete(rv)
          end
        end
  
        # Ensures existence of a list of schema objects.
        def expand_objects(schema_objects)
          schema_objects.each do |object| 
            case s = status[object]
              when :create, :alter
                expand_object(object)
              when :same, :expanded
                # nothing do to
              else
                msg = "Unexpected status #{s} for #{object} for schema expansion"
                raise AssumptionFailedError, msg
            end
          end
        end
        
        # Ensures existence of a single schema object
        def expand_object(object)
          parent = object.parent

          if status[parent] == :create
            #
            # Delegate to parent if it needs to be ensured itself
            #
            # Making this helps issuing a single CREATE TABLE instead of 
            # many ALTER TABLE statements, which are not always supported
            # by adapters.
            #
            expand_object(parent)
            
          else
            # Mark the object as being currently created
            status[object] = :pending
      
            # ensure dependencies
            expand_objects(object.outside_dependencies)
      
            # ensure itself and recurse on children
            expand_call = :"expand_#{object.builder_handler}"
            if object.composite?
              # ensure composite objects
              if self.respond_to?(expand_call)
                self.send(expand_call, object){ expand_objects(object.parts) }
              else
                expand_objects(object.parts)
              end
            else
              # ensure part objects
              self.send(expand_call, object)
            end

            # mark object as ensured!
            status[object] = :expanded
          end
        end
  
        ### Composites
  
        def expand_relvar_xxx(xxx)
          with_expand_helper(rv = xxx.relation_variable){|helper| yield}
        end
        alias :expand_relvar :expand_relvar_xxx
        alias :expand_heading :expand_relvar_xxx
  
        ### Parts

        def expand_attribute(attribute)
          with_expand_helper(rv = attribute.relation_variable){|helper|
            helper.attribute(attribute)
          }
        end

        def expand_candidate_key(ckey)
          with_expand_helper(rv = ckey.relation_variable){|helper|
            helper.candidate_key(ckey)
          }
        end

        def expand_foreign_key(fkey)
          with_expand_helper(rv = fkey.relation_variable){|helper|
            helper.foreign_key(fkey)
          }
        end

        def expand_index(index)
          with_expand_helper(rv = index.indexed_relvar){|helper|
            helper.index(index)
          }
        end

      end # class Stager
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
