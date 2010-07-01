module DbAgile
  module Tools
    module CSV
      class Config
        
        # Outputs the header?
        attr_accessor :include_header
        
        # Queries as a hash from names to SQL queries
        attr_accessor :queries
        
        # Output IO
        attr_accessor :output_io
        
        # Output folder of the generation
        attr_accessor :output_folder
        
        # Creates a config instance
        def initialize
          @queries = {}
          @include_header = false
        end
        
        # Yields the block with an IO object for a given query
        # name
        def output_io_for(name, &block)
          if output_io
            block.call(output_io)
          elsif output_folder.nil?
            block.call(STDOUT)
          else
            File.open(File.join(output_folder, "#{name}.csv"), "w", &block)
          end
        end
        
      end # class Config
    end # module CSV
  end # module Tools
end # module DbAgile