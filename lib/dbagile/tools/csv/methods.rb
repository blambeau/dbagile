module DbAgile
  module Tools
    module CSV
      module Methods
        
        # Lauches a to_csv process on a connection and configuration
        def to_csv(connection, config)
          config.queries.each_pair do |name, query|
            dataset = connection.dataset(query)
            columns = query.kind_of?(Symbol) ? connection.column_names(query) : dataset.columns
            config.output_io_for(name) do |io|
              FCSV(io) do |csv|
                csv << columns if config.include_header
                dataset.each do |row|
                  csv << columns.collect{|c| row[c]}
                end
              end
            end
          end
        end
        
      end # module Methods
    end # module CSV
  end # module Tools
end # module DbAgile