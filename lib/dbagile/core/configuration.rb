require 'dbagile/core/configuration/robustness'
require 'dbagile/core/configuration/dsl'
module DbAgile
  module Core
    #
    # Encapsulates configuration of a database handler.
    # 
    class Configuration
      
      # Configuration name
      attr_reader :name
      
      # Configuration uri
      attr_accessor :uri
      
      # Array of files for the announced schema
      attr_accessor :announced_files
      
      # Array of files for the effective schema
      attr_accessor :effective_files
      
      # Resolves relative files
      attr_accessor :file_resolver
      
      # Plugs as arrays of arrays
      attr_reader :plugs
      
      # Creates a configuration instance
      def initialize(name, uri = nil, &block)
        raise ArgumentError, "Configuration name is mandatory" unless name.kind_of?(Symbol)
        raise ArgumentError, "Configuration DSL is deprecated" unless block.nil?
        @name = name
        @uri = uri
        @announced_files = nil
        @effective_files = nil
        @file_resolver = lambda{|f| ::File.expand_path(f) }
        @connector = ::DbAgile::Core::Connector.new
      end
      
      
      
      ##############################################################################
      ### About configuration
      ##############################################################################
      
      # @see Connector#plug
      def plug(*args)
        (@plugs ||= []) << args
        @connector.plug(*args)
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
        raise DbAgile::Error, "Configuration has no database uri" if uri.nil?
        if uri =~ /:\/\//
          adapter = DbAgile::Adapter::factor(uri, options)
        elsif file_resolver
          file = file_resolver.call(uri)
          adapter = DbAgile::Adapter::factor("sqlite://#{file}", options)
        else
          raise DbAgile::Error, "A file resolver is required for using #{uri} as database uri"
        end
        connector = @connector.connect(adapter)
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
      
      # Does this configuration has announced schema files?
      def has_announced_schema?
        !(@announced_files.nil? or @announced_files.empty?)
      end
      
      # Does this configuration has effective schema files?
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
        return unless has_effective_schema?
        if effective_files.size > 1
          raise "Unable to set effective schema with multiple effective files"
        end
        file = file_resolver.call(effective_files[0])
        ::File.open(file, 'w') do |io|
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
      
      # Inspects this configuration, returning a ruby chunk of code
      # whose evaluation leads to a configuration instance
      def inspect(prefix = "")
        require 'sbyc/type_system/ruby'
        buffer = ""
        buffer << "#{prefix}config(#{name.inspect}){" << "\n"
        buffer << "  uri #{uri.inspect}" << "\n"
        if has_announced_schema?
          buffer << "  " << _friendly_files_inspect("announced", announced_files) << "\n"
        end
        if has_effective_schema?
          buffer << "  " << _friendly_files_inspect("effective", effective_files) << "\n"
        end
        if plugs and not(plugs.empty?)
          plugs.each{|plug| 
            plugs_str = plug.collect{|p| SByC::TypeSystem::Ruby::to_literal(p)}.join(', ')
            buffer << "  plug " << plugs_str << "\n"
          } 
        end
        buffer << "}"
      end
      
      def _friendly_files_inspect(name, files)
        if files.size == 1
          "#{name}_schema #{files[0].inspect}"
        else
          "#{name}_schema #{files.inspect}"
        end  
      end
      
      private :_friendly_files_inspect
    end # class Configuration
  end # module Core
end # module DbAgile 