module DbAgile
  module Tools
    module CSV
      module Methods
        
        # Lauches a to_csv process on a connection and configuration
        def csvout(connection, config)
          # CSV options
          csv_options = {:col_sep      => config.col_sep, 
                         :quote_char   => config.quote_char,
                         :force_quotes => config.force_quotes,
                         :skip_blanks  => config.skip_blanks}
          
          # For each query
          config.queries.each_pair do |name, query|
            dataset = connection.dataset(query)
            
            # Retrieve column names, ...
            # TODO: stop cheating here: we have an explicit Sequel
            #       assumption in the String part (dataset.columns is not part 
            #       of the contract)
            if query.kind_of?(Symbol)
              columns =  connection.column_names(query)
            else
              columns = dataset.columns
            end
            
            # Generate CSV file
            config.output_io_for(name) do |io|
              csv = FasterCSV.new(io, csv_options)
              csv << columns if config.include_header
              dataset.each do |row|
                csv << columns.collect{|c| row[c]}
              end
              csv.close
            end
            
          end # for each query
        end
        
      end # module Methods
    end # module CSV
  end # module Tools
end # module DbAgile