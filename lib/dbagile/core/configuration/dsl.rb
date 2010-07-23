module DbAgile
  module Core
    class Configuration
      
      #
      # Domain-Specific-Language implementation of configuration and config files
      #
      class DSL
        include DbAgile::Core::Configuration::Robustness
        
        # The Configuration::File instance passed at construction
        attr_reader :config_file
        
        # The current Configuration instance
        attr_reader :configuration
        
        # Creates a DSL instance
        def initialize(config_file = nil, configuration = nil, &block)
          @config_file = config_file
          @configuration = configuration
          self.instance_eval(&block) unless block.nil?
        end
        
        # Adds a configuration under a given name
        def config(name, &block)
          valid_configuration_name!(name)
          created = with_config(Configuration.new(name)){|cfg|
            self.instance_eval(&block)
            cfg
          }
          unless config_file.nil?
            config_file.configurations << created
          end
          created
        end
        
        # Sets the database uri on the current configuration
        def uri(str)
          dsl_has_configuration!
          valid_database_uri!(str)
          configuration.uri = str
        end
        
        # Sets the schema file
        def schema_file(file)
          dsl_has_configuration!
          configuration.schema_files << file
        end
        
        # Sets the schema files
        def schema_files(*files)
          dsl_has_configuration!
          files.flatten.each{|f| configuration.schema_files << f}
        end
        
        # @see DbAgile::Core::Configuration#plug
        def plug(*args)
          dsl_has_configuration!
          configuration.plug(*args)
        end
        
        # Sets the current configuration
        def current_config(name)
          dsl_has_config_file!
          config_file.current_config_name = name
        end
        
        ###
        
        private 

        # Yields the block with a configuration
        def with_config(cfg)
          if cfg.kind_of?(DbAgile::Core::Configuration)
            @configuration = cfg
            result = yield(cfg)
            @configuration = nil
            result
          elsif cfg.kind_of?(Symbol) or cfg.nil?
            dsl_has_config_file!
            has_config!(config_file, cfg)
            with_config(config_file.config(cfg), &block)
          end
        end
        
        # Asserts that there is a current configuration
        def dsl_has_configuration!
          raise DbAgile::Error, "Invalid Configuration::DSL usage, no current config" if configuration.nil?
        end
        
        # Asserts that there is a current config file
        def dsl_has_config_file!
          raise DbAgile::Error, "Invalid Configuration::DSL usage, no current config file" if config_file.nil?
        end
        
      end # class DSL
    end # class Configuration
  end # module Core
end # module DbAgile