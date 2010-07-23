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
      
      # Plugs as arrays of arrays
      attr_reader :plugs
      
      # Creates a configuration instance
      def initialize(name, uri = nil, &block)
        raise ArgumentError, "Configuration name is mandatory" unless name.kind_of?(Symbol)
        raise ArgumentError, "Configuration DSL is deprecated" unless block.nil?
        @name = name
        @uri = uri
        @connector = ::DbAgile::Core::Connector.new
      end
      
      # @see Connector#plug
      def plug(*args)
        (@plugs ||= []) << args
        @connector.plug(*args)
      end
      
      # Checks if the connection pings correctly.
      def ping?
        connect.ping?
      end
      
      # Connects and returns a Connection object
      def connect(options = {})
        raise ArgumentError, "Options should be a Hash" unless options.kind_of?(Hash)
        raise DbAgile::Error, "Configuration has no database uri" if uri.nil?
        adapter = DbAgile::Adapter::factor(uri, options)
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
      
      # Inspects this configuration, returning a ruby chunk of code
      # whose evaluation leads to a configuration instance
      def inspect(prefix = "")
        require 'sbyc/type_system/ruby'
        buffer = ""
        buffer << "#{prefix}config(#{name.inspect}){" << "\n"
        buffer << "  uri #{uri.inspect}" << "\n"
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