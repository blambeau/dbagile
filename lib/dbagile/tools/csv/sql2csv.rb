module DbAgile
  module Tools
    module CSV
      class SQL2CSV < DbAgile::Commands::Command
        include DbAgile::Tools::CSV::Methods
        
        # Database URI to use
        attr_accessor :uri
        
        # Configuration instance
        attr_accessor :config
        
        # Creates a command instance
        def initialize
          super
          @config = DbAgile::Tools::CSV::Config.new
        end
        
        # Contribute to options
        def add_options(opt)
          opt.on("--uri=URI", "-u", "Database URI to use") do |value|
            self.uri = value
          end
          opt.on("--output-folder=FOLDER", "-o", "Generate files into folder") do |value|
            self.config.output_folder = value
          end
          opt.on("--stdout", "Generate CSV on standard output") do
            self.config.output_io = STDOUT
          end
          opt.on("--include-header", "-h", "Flush columns names as first line") do
            self.config.include_header = true
          end
          opt.on("--separator=C", "Use C as columns separator character") do |value|
            self.config.col_sep = value
          end
          opt.on("--quote=C", "Use C as quoting character") do |value|
            self.config.quote_char = value
          end
          opt.on("--force-quotes", "Force quoting?") do 
            self.config.force_quotes = true
          end 
          opt.on("--skip-blanks", "Skip blank lines?") do 
            self.config.skip_blanks = true
          end 
        end

        # Returns the command banner
        def banner
          "sql2csv [options] table"
        end
      
        # Normalizes arguments
        def normalize_pending_arguments(arguments)
          exit("Missing database uri", true) if self.uri.nil?
          exit("Missing table name", true) if arguments.empty?
          if config.output_io.nil? and config.output_folder.nil?
            config.output_folder = File.expand_path('.')
          end
          arguments.each{|a| self.config.queries[a.to_sym] = a.to_sym}
        end
        
        # Executes the command
        def execute_command
          conn = DbAgile::connect(uri)
          csvout(conn, config)
        rescue Sequel::Error => ex
          exit(ex.message, false)
        end    
        
      end # class SQL2CSV
    end # module CSV
  end # module Tools
end # module DbAgile