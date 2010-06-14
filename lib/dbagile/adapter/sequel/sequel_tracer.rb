module DbAgile
  class SequelAdapter
    class SequelTracer
      include DbAgile::Adapter::Delegate
    
      ### INIT AND OPTIONS #########################################################
    
      # Default options of this adapter
      DEFAULT_OPTIONS = {
        :trace_sql    => false,
        :trace_only   => false,
        :trace_buffer => nil
      }
      
      # Delegation to SequelAdapter
      attr_reader :delegate
      
      # Creates a tracer instance
      def initialize(delegate, options)
        @delegate = delegate
        @options = DEFAULT_OPTIONS.merge(options)
      end
      
      # Tracing is on?
      def trace?
        @trace ||= (@options[:trace_sql] && !trace_buffer.nil?)
      end
      
      # Only traces, forget about delegation?
      def trace_only?
        @trace_only ||= @options[:trace_only]
      end
      
      # Returns the tracing buffer
      def trace_buffer
        @buffer ||= @options[:trace_buffer]
      end
      
      ### UTILS ####################################################################
      
      # Returns SQL statement for a given alter table block
      def alter_table_sql(table_name, &block)
        generator = ::Sequel::Schema::AlterTableGenerator.new(self, &block)
        sqls = delegate.db.send(:alter_table_sql_list, table_name, generator.operations).flatten
        sqls.join("\n")
      end
      
      ### SCHEMA UPDATES ###########################################################
      
      #
      # Creates a table with some columns. 
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] columns column definitions
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database does not contain a table with that name
      # @post the database contains a table with specified columns
      #
      def create_table(table_name, columns)
        if trace?
          gen = ::Sequel::Schema::Generator.new(self){
            columns.each_pair{|name, type| column(name, type)}
          }
          sql = delegate.db.send(:create_table_sql, table_name, gen, {})
          trace(sql)
        end
        return super unless trace_only?
        nil
      end
      
      #
      # Adds some columns to a table
      #
      # @param [Symbol] table_name the name of a table
      # @param [Hash] columns column definitions
      # @return [Boolean] true to indicate that everything is fine
      #
      # @pre the database contains a table with that name
      # @pre the table does not contain any of the columns
      # @post the table has gained the additional columns
      #
      def add_columns(table_name, columns)
        if trace?
          trace(alter_table_sql(table_name){ 
            columns.each_pair{|name, type| add_column(name, type)}
          })
        end
        return super unless trace_only?
        nil
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
      def key!(table_name, columns)
        if trace?
          trace(alter_table_sql(table_name){ 
            add_index(columns, :unique => true)
          })
        end
        return super unless trace_only?
        nil
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
        if trace?
          trace(delegate.db[table_name].insert_sql(record)) 
        end
        return super unless trace_only?
        record
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
        if trace?
          trace(sql)
        end
        return super unless trace_only?
        nil
      end
    
      ### ABOUT TRACING ############################################################
    
      # Traces a SQL statement. Returns true if trace_only, false
      # otherwise
      def trace(sql)
        case out = trace_buffer
          when Logger
            out.info(sql)
          else
            out << "#{sql}\n"
        end
        sql
      end
    
    end # class SequelTracer
  end # class SequelAdapter
end # module DbAgile