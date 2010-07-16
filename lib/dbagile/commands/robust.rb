module DbAgile
  module Commands
    module Robust
      
      # Raises an OptionParser::InvalidArgument
      def bad_argument_list!(rest)
        raise OptionParser::InvalidArgument, "#{rest.join(' ')}"
      end
      
      # Parses pending arguments, assert that it contains exactly
      # types.size arguments, and convert them to types.
      def valid_argument_list!(rest, *types)
        if rest.size == types.size
          rest.zip(types).collect do |arg, type|
            if String == type
              arg.to_s
            elsif Symbol == type
              arg.to_sym
            else
              raise OptionParser::InvalidArgument, arg
            end
          end
        elsif rest.size < types.size
          raise OptionParser::MissingArgument
        else
          raise OptionParser::NeedlessArgument, rest
        end
      end
      
      # Asserts that a configuration name is valid or raises
      # a InvalidConfigurationName error
      def valid_configuration_name!(name)
        raise DbAgile::InvalidConfigurationName, "Invalid configuration name #{name}"\
          unless name.kind_of?(Symbol) and /[a-z][a-z0-9_]*/ =~ name.to_s
        name
      end
      
      # Asserts that a database uri is valid or raises
      # a InvalidDatabaseUri error
      def valid_database_uri!(uri)
        require 'uri'
        got = URI::parse(uri)
        if got.scheme.nil?
          raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}" 
        end
        uri
      rescue URI::InvalidURIError
        raise DbAgile::InvalidDatabaseUri, "Invalid database uri: #{uri}"
      end
        
      #
      # Asserts that a command exists or raises a NoSuchCommandError.
      # 
      # @return [DbAgile::Commands::Command] the command instance
      #
      def has_command!(name)
        cmd = DbAgile::Commands::Command.command_for(name)
        if cmd.nil?
          raise DbAgile::NoSuchCommandError, "No such command #{name.inspect}" 
        else
          cmd
        end
      end
      
      #
      # Asserts that a configuration exists. When config_name is nil, asserts
      # that a default configuration is set.
      #
      # @return [DbAgile::Core::Configuration] the configuration instance when 
      # found.
      #
      def has_config!(config_file, config_name = nil)
        config = if config_name.nil?
          config_file.current_config
        else 
          config_file.config(config_name)
        end
        if config.nil?
          raise DbAgile::UnknownConfigError, "Unknown configuration #{config_name}" if config_name
          raise DbAgile::NoDefaultConfigError, "No default configuration set (try 'dba use ...' first)"
        else
          config
        end
      end
      
    end # module Robust
  end # module Commands 
end # module DbAgile