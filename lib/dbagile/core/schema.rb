require 'dbagile/core/schema/yaml_methods'
require 'dbagile/core/schema/builder'
require 'dbagile/core/schema/logical'
require 'dbagile/core/schema/physical'
module DbAgile
  module Core
    #
    # Encapsulates the notion of database schema.
    #
    class Schema
      extend(DbAgile::Core::Schema::YAMLMethods)
      
      # Logical schema
      attr_reader :logical
      
      # Physical schema
      attr_reader :physical
      
      # Creates a schema instance
      def initialize(logical = {}, physical = {})
        @logical, @physical = logical, physical
      end
      
      # Dumps the schema to YAML
      def to_yaml(opts = {})
        ls = Schema::Coercion::unsymbolize_hash(logical)
        ps = Schema::Coercion::unsymbolize_hash(physical)
        if ps['indexes']
          ps['indexes'] = Schema::Coercion::unsymbolize_hash(ps['indexes'])
        end
        objects = {'logical' => ls, 'physical' => ps}.delete_if{|k,v| v.empty?}
        YAML::dump_stream(objects)
      end
      alias :inspect :to_yaml
      
      # Checks if this relvar is empty
      def empty?
        logical.empty? and physical.empty?
      end
          
      # Applies schema minus
      def minus(other, builder = Schema::Builder.new)
        raise ArgumentError, "Schema expected" unless other.kind_of?(Schema)
        builder.logical{|b_logical|
          mlk, olk = logical.keys, other.logical.keys
          mine, common = (mlk - olk), mlk.select{|k| olk.include?(k)}
          mine.each{|m| b_logical[m] = logical[m]}
          common.each{|m| 
            b_logical[m] = logical[m].minus(other.logical[m], builder)
          }
        }
        builder.physical{
          builder.indexes{|b_indexes|
            mik, oik = physical[:indexes].keys, other.physical[:indexes].keys
            mine, common = (mik - oik), mik.select{|k| oik.include?(k)}
            mine.each{|m| b_indexes[m] = physical[:indexes][m]}
            common.each{|m| 
              unless physical[:indexes][m] == other.physical[:indexes][m]
                b_indexes[m] = physical[:indexes][m]
              end
            }
          }
        }
        builder._dump.strip!
      end
      alias :- :minus
      
      # Removes empty relvars
      def strip!
        logical.delete_if{|k, v| v.empty?}
        physical.delete_if{|k, v| v.empty?}
        self
      end
      
      # Compares with another attribute
      def ==(other)
        return nil unless other.kind_of?(Schema)
        (logical == other.logical) and (physical == other.physical)
      end
    
      # Yields the block with each relvar in turn
      def each_relvar(&block)
        logical.values.each(&block)
      end
      
    end # class Schema
  end # module Core
end # module DbAgile