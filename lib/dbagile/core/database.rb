module DbAgile
  module Core
    #
    # Encapsulates a database handler.
    # 
    class Database
      
      # Database name
      attr_reader :name
      
      # Database uri
      attr_accessor :uri
      
      # Array of files for the announced schema
      attr_accessor :announced_files
      alias :announced_schema= :announced_files=
      
      # Array of files for the effective schema
      attr_accessor :effective_files
      alias :effective_schema= :effective_files=
      
      # Resolves relative files
      attr_accessor :file_resolver
      
      # Plugs as arrays of arrays
      attr_reader :plugs
      
      # Creates a database instance
      def initialize(name, uri = nil, &block)
        raise ArgumentError, "Database name is mandatory" unless name.kind_of?(Symbol)
        raise ArgumentError, "Database DSL is deprecated" unless block.nil?
        @name = name
        @uri = uri
        @announced_files = []
        @effective_files = []
        @file_resolver = lambda{|f| ::File.expand_path(f) }
        @chain = ::DbAgile::Core::Chain.new
      end
      
      
      
      ##############################################################################
      ### About connector
      ##############################################################################
      
      # @see Chain#plug
      def plug(*args)
        (@plugs ||= []).push(*args)
        @chain.plug(*args)
      end
      
      # Installs plugins
      def plugins=(plugins)
        plugins = plugins.collect{|p| Kernel.eval(p)}
        plug(*plugins)
      end
      
      
      ##############################################################################
      ### About connection
      ##############################################################################
      
      # Checks if the connection pings correctly.
      def ping?
        connect.ping?
      end
      
      # Connects and returns a Connection object
      def connect(options = {})
        raise ArgumentError, "Options should be a Hash" unless options.kind_of?(Hash)
        raise DbAgile::Error, "Database has no uri" if uri.nil?
        if uri =~ /:\/\//
          adapter = DbAgile::Adapter::factor(uri, options)
        elsif file_resolver
          file = file_resolver.call(uri)
          adapter = DbAgile::Adapter::factor("sqlite://#{file}", options)
        else
          raise DbAgile::Error, "A file resolver is required for using #{uri} as database uri"
        end
        connector = @chain.connect(adapter)
        Connection.new(connector)
      end
      
      #
      # Yields the block with a connection; disconnect after that.
      #
      # @raise ArgumentError if no block is provided
      # @return block execution result
      #
      def with_connection(conn_options = {})
        raise ArgumentError, "Missing block" unless block_given?
        begin
          connection = connect(conn_options)
          result = yield(connection)
          result
        ensure
          connection.disconnect if connection
        end
      end
      
      ##############################################################################
      ### About schema
      ##############################################################################
      
      # Does this database has announced schema files?
      def has_announced_schema?
        !(@announced_files.nil? or @announced_files.empty?)
      end
      
      # Does this database has effective schema files?
      def has_effective_schema?
        !(@effective_files.nil? or @effective_files.empty?)
      end
      
      # Loads a schema from schema files
      def load_schema_from_files(files)
        builder = DbAgile::Core::Schema::builder
        builder.schema(files){
          files.collect{|f| file_resolver.call(f)}.each{|f|
            DbAgile::Core::Schema::yaml_file_load(f, builder)
          }
        }
        builder._dump
      end
      
      # Returns the schema of highest level (announced -> effective -> physical).
      def schema
        announced_schema(true)
      end
      
      # Returns the announced schema. If no announce schema files are installed
      # and unstage is true, returns the effective schema. Returns nil otherwise.
      def announced_schema(unstage = false)
        if has_announced_schema?
          load_schema_from_files(announced_files)
        elsif unstage
          effective_schema(unstage)
        else
          nil
        end
      end
      
      # Overrides announced schema with a given schema
      def set_announced_schema(schema)
        # Set announced files
        self.announced_files ||= []
        case announced_files.size
          when 0
            FileUtils.mkdir_p(file_resolver.call(name))
            self.announced_files = [ "#{name}/announced.yaml" ]
          when 1
          else 
            raise "Unable to set announced schema with multiple effective files"
        end
        ::File.open(file_resolver.call(announced_files[0]), 'w') do |io|
          io << schema.to_yaml
        end
      end
      
      # Returns the effective schema. If no effective files are installed and 
      # unstage is true, returns the physical schema. Returns nil otherwise.
      def effective_schema(unstage = false)
        if has_effective_schema?
          load_schema_from_files(effective_files)
        elsif unstage
          physical_schema
        else
          nil
        end
      end
      
      # Overrides effective schema with a given schema
      def set_effective_schema(schema)
        # Set effective files
        self.effective_files ||= []
        case effective_files.size
          when 0
            FileUtils.mkdir_p(file_resolver.call(name.to_s))
            self.effective_files = [ "#{name}/effective.yaml" ]
          when 1
          else 
            raise "Unable to set effective schema with multiple effective files"
        end
        ::File.open(file_resolver.call(effective_files[0]), 'w') do |io|
          io << schema.to_yaml
        end
      end
      
      # Returns the database physical schema
      def physical_schema
        with_connection{|c| c.physical_schema}
      end
      
      private :load_schema_from_files
      
      ##############################################################################
      ### About io
      ##############################################################################
      
      # Converts this database to a yaml string
      def to_yaml(opts = {})
        YAML::quick_emit(self, opts){|out|
          out.map("tag:yaml.org,2002:map") do |map|
            map.add('uri', self.uri)
            if has_announced_schema?
              map.add('announced_schema', self.announced_files || [])
            end
            if has_effective_schema?
              map.add('effective_schema', self.effective_files || [])
            end
            if plugs and not(plugs.empty?) 
              ps = plugs.collect{|p| SByC::TypeSystem::Ruby::to_literal(p)}
              map.add('plugins', ps)
            end
          end
        }
      end
      
    end # class Database
  end # module Core
end # module DbAgile 