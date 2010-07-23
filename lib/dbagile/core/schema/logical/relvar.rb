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
            @constraints = Schema::NamedCollection.new(:constraints)
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
          
          # Yields the block with each attribute 
          def each_attribute(&block)
            heading.each_attribute(&block)
          end
          
          # Returns the relation variable primary key
          def primary_key
            constraints.each{|c|
              return c if c.kind_of?(Logical::Constraint::CandidateKey) and c.primary?
            }
            raise InvalidSchemaError, "Relation variable #{name} has no primary key!"
          end
          
          # Yiels the block with each foreign key
          def each_foreign_key(&block)
            constraints.select{|c|
              c.kind_of?(Logical::Constraint::ForeignKey)
            }.each(&block)
          end
          
          # Delegate pattern on minus
          def minus(other, builder)
            raise ArgumentError, "Relvar expected" unless other.kind_of?(Relvar)
            builder.relvar(name){
              heading.minus(other.heading, builder)
              constraints.minus(other.constraints, builder)
            }
          end
        
          # Checks if this relvar is empty
          def empty?
            heading.empty? and constraints.empty?
          end
          
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Relvar)
            (name == other.name) and (heading == other.heading) and (constraints == other.constraints)
          end
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              out.map("tag:yaml.org,2002:map", to_yaml_style ) do |map|
                map.add('heading', heading) unless heading.empty?
                map.add('constraints', constraints) unless constraints.empty?
              end
            }
          end
        
        end # class Relvar
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
