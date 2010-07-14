module DbAgile
  module Tools
    module CSV
      class Config
        
        # Outputs the header?
        attr_accessor :include_header
        
        # Column separator, ';' by default
        attr_accessor :col_sep
        
        # Quote character, '"' by default
        attr_accessor :quote_char
        
        # Force quoting ?
        attr_accessor :force_quotes
        
        # Skip blanks?
        attr_accessor :skip_blanks
        
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
          @col_sep = ';'
          @quote_char = '"'
          @force_quotes = false
          @skip_blanks = false
        end
        
        # Yields the block with an IO object for a given query
        # name
        def output_io_for(name, &block)
          if output_io
            block.call(output_io)
          elsif output_folder.nil?
            block.call(STDOUT)
          else
            require 'fileutils'
            file = File.join(output_folder, "#{name}.csv")
            FileUtils.mkdir_p(File.dirname(file))
            File.open(file, "w", &block)
          end
        end
        
      end # class Config
    end # module CSV
  end # module Tools
end # module DbAgile