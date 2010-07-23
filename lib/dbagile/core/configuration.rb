require 'dbagile/core/configuration/robustness'
require 'dbagile/core/configuration/dsl'
require 'dbagile/core/configuration/file'
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
      
      # Array of schema files
      attr_reader :schema_files
      
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
        @schema_files = []
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
      
      # Returns true if schema files are installed, false otherwise
      def has_schema_files?
        not(schema_files.nil? or schema_files.empty?)
      end
      
      # Loads the schema from the schema files
      def schema
        if has_schema_files?
          builder = DbAgile::Core::Schema::Builder.new
          schema_files.collect{|f| file_resolver.call(f)}.each{|f|
            DbAgile::Core::Schema::yaml_file_load(f, builder)
          }
          builder._dump
        else
          nil
        end
      end
      
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
        if has_schema_files?
          if schema_files.size == 1
            buffer << "  schema_file #{schema_files[0].inspect}" << "\n"
          else
            buffer << "  schema_files #{schema_files.inspect}" << "\n"
          end
        end
        if plugs and not(plugs.empty?)
          plugs.each{|plug| 
            plugs_str = plug.collect{|p| SByC::TypeSystem::Ruby::to_literal(p)}.join(', ')
            buffer << "  plug " << plugs_str << "\n"
          } 
        end
        buffer << "}"
      end
      
    end # class Configuration
  end # module Core
end # module DbAgile 