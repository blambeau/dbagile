module DbAgile
  module Commands
    module Robust
      
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