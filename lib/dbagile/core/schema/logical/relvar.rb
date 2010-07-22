module DbAgile
  module Core
    class Schema
      module Logical
        class Relvar
        
          # Relvar name
          attr_reader :name
        
          # Relvar heading
          attr_reader :heading
        
          # Relvar constraints
          attr_reader :constraints
        
          # Creates a relation variable instance
          def initialize(name)
            @name = name.to_s.to_sym
            @heading = Schema::Logical::Heading.new
            @constraints = {}
          end
        
          # Mimics a hash on heading and constraints
          def [](name)
            case name
              when :heading 
                self.heading
              when :constraints
                self.constraints
              else
                raise ArgumentError, "No such mimics method #{name} on Relvar"
            end
          end
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              out.map("tag:yaml.org,2002:map", to_yaml_style ) do |map|
                map.add('heading', heading)
                map.add('constraints', Schema::Coercion::unsymbolize_hash(constraints))
              end
            }
          end
        
        end # class Relvar
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
