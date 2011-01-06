module DbAgile
  class SequelAdapter < Adapter
    module Schema
      module ConcreteScript
        include Schema::Schema2SequelArgs
        
        # Converts an abstract script to a concrete one
        def script2sql(conn, script, buffer)
          script.each{|op| self.send(op.kind, conn, op, buffer)}
          buffer
        end
        
        def create_view(conn, op, buffer)
          tname = conn.send(:quote_schema_table, op.table_name)
          buffer <<  "CREATE VIEW #{tname} AS #{op.relview.definition};" << "\n"
          staged!(op)
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end
        
        def drop_view(conn, op, buffer)
          tname = conn.send(:quote_schema_table, op.table_name)
          buffer <<  "DROP VIEW #{tname};" << "\n"
          staged!(op)
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end
        
        def create_table(conn, op, buffer)
          gen = Sequel::Schema::Generator.new(conn)
          build_sequel_expand_generator(conn, op, gen, "")
          buffer << to_sql(conn, op, gen)
          staged!(op)
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end

        def expand_table(conn, op, buffer)
          gen = Sequel::Schema::AlterTableGenerator.new(conn)
          build_sequel_expand_generator(conn, op, gen, "add_")
          buffer << to_sql(conn, op, gen)
          staged!(op)
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end

        def collapse_table(conn, op, buffer)
          gen = Sequel::Schema::AlterTableGenerator.new(conn)
          build_sequel_collapse_generator(conn, op, gen, "drop_")
          buffer << to_sql(conn, op, gen)
          staged!(op)
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end

        # Drops table
        def drop_table(conn, op, buffer)
          buffer << conn.send(:drop_table_sql, op.table_name) << ";\n"
          op.relvar.visit{|obj,parent| op.staged!(obj)}
        rescue Sequel::Error => ex
          buffer << "-- UNSUPPORTED: #{op.to_sql92}" << "\n"
          unsupported!(op)
        end
        
        # Mark objects as staged for an operation
        def staged!(op)
          if op.supports_sub_operation?(nil)
            op.each_sub_operation{|kind, operand| op.staged!(operand)}
          end
          op.staged!(op.relvar)
        end
        
        # Mark objects as not staged for an operation
        def unsupported!(op)
          if op.supports_sub_operation?(nil)
            op.each_sub_operation{|kind, operand| op.not_staged!(operand)}
          end
          op.not_staged!(op.relvar)
        end
        
        # Builds a sequel expand generator
        def build_sequel_expand_generator(conn, op, generator, prefix)
          op.each_sub_operation{|kind, operand|
            case kind
              when :attribute
                args = attribute2column_args(operand)
                generator.send(:"#{prefix}column", *args)
              when :candidate_key
                if operand.primary?
                  args = candidate_key2primary_key_args(operand)
                  generator.send(:"#{prefix}primary_key", *args) 
                else
                  args = candidate_key2unique_args(operand)
                  generator.send(:"#{prefix}unique", *args)
                end
              when :foreign_key
                args = foreign_key2foreign_key_args(operand)
                generator.send(:"#{prefix}foreign_key", *args)
              when :index
                args = index2index_args(operand)
                generator.send(:"#{prefix}index", *args)
              else
                raise DbAgile::AssumptionFailedError, "Unknown script operation kind #{kind}"
            end
          }
        end
        
        # Builds a sequel collapse generator
        def build_sequel_collapse_generator(conn, op, generator, prefix)
          op.each_sub_operation{|kind, operand|
            case kind
              when :attribute
                args = [ operand.name ]
                generator.send(:"#{prefix}column", *args)
              when :candidate_key, :foreign_key
                args = [ operand.name ]
                generator.send(:"#{prefix}constraint", *args) 
              when :index
                column_names = operand.indexed_attributes.collect{|a| a.name}
                args = [ column_names, {:name => operand.name}]
                generator.send(:"#{prefix}index", *args)
              else
                raise DbAgile::AssumptionFailedError, "Unknown script operation kind #{kind}"
            end
          }
        end
        
        # Converts a sequel generator to SQL for a given operation
        def to_sql(conn, op, generator)
          case generator
            when Sequel::Schema::Generator
              sql = conn.send(:create_table_sql, op.table_name, generator, {})
              sql = sql + ";\n"
              sql
            when Sequel::Schema::AlterTableGenerator
              sql = conn.send(:alter_table_sql_list, op.table_name, generator.operations)
              sql = sql.flatten.join(";\n")
              sql + ";\n"
            else
              raise DbAgile::AssumptionFailedError, "Unknown generator #{gen.class}"
          end
        end
        
        extend(ConcreteScript)
      end # module ConcreteScript
    end # module Schema
  end # class SequelAdapter
end # module DbAgile
