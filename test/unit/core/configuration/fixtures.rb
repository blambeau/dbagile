require File.expand_path('../../../fixtures', __FILE__)
module DbAgile
  module Fixtures
    module Core
      module Configuration
      
        # Returns a config file
        def config_file(name_or_file)
          if name_or_file.kind_of?(Symbol)
            name_or_file = config_file("#{name_or_file}.dba") 
          end
          unless name_or_file[0, 1] == '/'
            name_or_file = File.expand_path("../fixtures/#{name_or_file}", __FILE__) 
          end
          name_or_file
        end
        
        # Yields block for each config file
        def each_config_file(&block)
          Dir[File.expand_path("../fixtures/*.cfg", __FILE__)].each(&block)
        end
        
        # Returns a Schema instance for a given name
        def config(name_or_file)
          src = File.read(config_file(name_or_file))
          Kernel::eval(src)
        end

        extend(Configuration)
      end # module Configuration
    end # module Core
  end # module Fixtures
end # module DbAgile