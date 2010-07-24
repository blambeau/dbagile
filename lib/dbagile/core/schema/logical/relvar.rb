module DbAgile
  module Core
    class Schema
      class Logical < Schema::Brick
        class Relvar < Schema::Brick
        
          # Sub brick keys
          BRICK_SUBBRICK_KEYS = [:heading, :constraints]
        
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
            @constraints = Schema::Logical::Constraints.new
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
          
          ############################################################################
          ### DbAgile::Core::Schema::Brick
          ############################################################################
        
          # @see DbAgile::Core::Schema::Brick#brick_composite?
          def brick_composite?
            true
          end
          
          # @see DbAgile::Core::Schema::Brick#brick_empty?
          def brick_empty?
            heading.brick_empty? and constraints.brick_empty?
          end
          
          # @see DbAgile::Core::Schema::Brick#brick_subbrick_keys
          def brick_subbrick_keys
            BRICK_SUBBRICK_KEYS
          end 
          
          # @see DbAgile::Core::Schema::Brick#brick_children
          def brick_children
            [ heading, constraints ]
          end
        
          # @see DbAgile::Core::Schema::Brick#[]
          def [](name)
            return self.heading if name == :heading
            return self.constraints if name == :constraints
            raise ArgumentError, "No such mimics method #{name} on Relvar"
          end
          
          # @see DbAgile::Core::Schema::Brick#[]=
          def []=(name, value)
            if (name == :heading) and value.kind_of?(Logical::Heading)
              @heading = value 
              value.send(:parent=, self)
            elsif name == :constraints and value.kind_of?(Logical::Constraints)
              @constraints = value
              value.send(:parent=, self)
            else
              raise ArgumentError, "Relvar does not accept #{value.class} for #{name}"
            end
          end
          
          ############################################################################
          ### Equality and hash code
          ############################################################################
        
          # Compares with another attribute
          def ==(other)
            return nil unless other.kind_of?(Relvar)
            (name == other.name) and (heading == other.heading) and (constraints == other.constraints)
          end
        
          # Returns an hash code
          def hash
            [ name, heading, constraints ].hash
          end
          
          # Duplicates this attribute
          def dup
            dup = Logical::Relvar.new(name)
            dup[:heading] = heading.dup
            dup[:constraints] = constraints.dup
            dup
          end
        
          ############################################################################
          ### About IO
          ############################################################################
        
          # Delegation pattern on YAML flushing
          def to_yaml(opts = {})
            YAML::quick_emit(self, opts){|out|
              out.map("tag:yaml.org,2002:map", to_yaml_style ) do |map|
                map.add('heading', heading) unless heading.brick_empty?
                map.add('constraints', constraints) unless constraints.brick_empty?
              end
            }
          end
        
        end # class Relvar
      end # module Logical
    end # class Schema
  end # module Core
end # module DbAgile
