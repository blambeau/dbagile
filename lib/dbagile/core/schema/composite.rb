module DbAgile
  module Core
    module Schema
      class Composite < SchemaObject
      
        # Creates a composite instance with parts
        def initialize(composite_parts = _default_parts)
          unless composite_parts.kind_of?(Hash)
            raise ArgumentError, "Composite parts must be a hash, got #{composite_parts.inspect}" 
          end
          _install_parts(composite_parts)
          @insert_order = nil
        end
      
        ############################################################################
        ### Private interface
        ############################################################################
        attr_reader :composite_parts
        protected   :composite_parts
        private
      
        # Creates defaut parts hash
        def _default_parts
          {}
        end
      
        # Returns prefered keys order
        def _prefered_order
          @insert_order || []
        end
        
        def _prefered_order=(order)
          @insert_order = order
        end
        
        # Make installation of parts
        def _install_parts(parts)
          meth = _install_eigenclass_methods?
          parts.each_pair{|k, v|
            v.send(:parent=, self)
            if meth
              eigenclazz = (class << self; self; end)
              eigenclazz.send(:define_method, k){ @composite_parts[k] }
            end
          }
          @composite_parts = parts
        end
      
        # Installs eigenclass methods on parts provided at construction
        def _install_eigenclass_methods?
          false
        end
        
        # Duplicates parts
        def _dup_parts
          dup_parts = {}
          @composite_parts.each_pair{|name, part| dup_parts[name] = part.dup}
          dup_parts
        end
        
        protected
        
        # Removes empty objects from parts
        def _strip!
          parts.each{|p| p._strip! if p.composite?}
          to_remove = part_keys.select{|k| 
            self[k].composite? and self[k].empty?
          }
          @composite_parts.delete_if{|k, v| 
            to_remove.include?(k)
          }
          if @insert_order
            @insert_order -= to_remove 
          end
          _sanity_check(schema)
          self
        end
        
        # Makes a sanity check on the composite
        def _sanity_check(schema)
          if @insert_order
            too_much = @insert_order - @composite_parts.keys
            missing = @composite_parts.keys - @insert_order
            unless too_much.empty? and missing.empty?
              raise SchemaInternalError, "Key divergence" 
            end
          end
          parts.each{|p| 
            raise SchemaInternalError, "Invalid parent on #{self}" unless p.parent == self
            raise SchemaInternalError, "Invalid schema on on #{self}" unless p.schema == schema
            p._sanity_check(schema) 
          }
        rescue StandardError => ex
          raise SchemaInternalError, "Something goes wrong on #{self}: #{ex.message}", ex.backtrace
        end
      
        # Checks this composite's semantics and collect errors
        def _semantics_check(clazz, buffer)
          parts.collect{|p| p._semantics_check(clazz, buffer)}
        end
        
        ############################################################################
        ### Public interface
        ############################################################################
        public
      
        # Returns an array with part dependencies
        def dependencies(include_parent = false)
          deps = parts.collect{|p| p.dependencies(include_parent)}.flatten.uniq
          deps += [ parent ] if include_parent and not(parent.nil?)
          deps
        end
        
        # Yields the block with each part in turn
        def each_part(&block)
          parts.each(&block)
        end
        
        # @see DbAgile::Core::Schema
        def visit(&block)
          block.call(self, parent)
          parts.each{|p| p.visit(&block)}
        end
        
        ############################################################################
        ### SchemaObject
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def empty?(recurse = true)
          if recurse
            parts.all?{|p| p.composite? && p.empty?(recurse)}
          else
            @composite_parts.empty?
          end
        end
        
        # Returns number of parts
        def size
          @composite_parts.size
        end
      
        # @see DbAgile::Core::SchemaObject
        def part_keys(sort = false)
          if sort
            @composite_parts.keys.sort{|k1,k2| k1.to_s <=> k2.to_s}
          else
            (_prefered_order + @composite_parts.keys).uniq
          end
        end
      
        # @see DbAgile::Core::SchemaObject
        def parts
          part_keys(false).collect{|k| self[k]}
        end
      
        # @see DbAgile::Core::SchemaObject
        def [](name)
          @composite_parts[name]
        end
      
        # @see DbAgile::Core::SchemaObject
        def []=(name, part, status = nil)
          if @composite_parts.key?(name)
            raise SchemaConflictError.new(self[name], part, name)
          end
          @composite_parts[name] = part
          (@insert_order ||= []) << name
          part.send(:parent=, self)
          unless status.nil?
            part.visit{|p, parent| p.status = status}
          end
          part
        end
      
        ############################################################################
        ### About IO
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def to_yaml(opts = {})
          YAML::quick_emit(self, opts){|out|
            out.map("tag:yaml.org,2002:map") do |map|
              part_keys.each{|k|
                map.add(k.to_s, self[k])
              }
            end
          }
        end
        
        # Returns a yaml string
        def yaml_say(env, 
                     options = {}, 
                     colors = DbAgile::Core::Schema::STATUS_TO_COLOR, 
                     indent = 0)
          part_keys.each{|k|
            part = self[k]
            status = part.status.to_s.ljust(25)
            show_it = !(part.status == Schema::NO_CHANGE and options[:skip_unchanged])
            if show_it
              mine = "  "*indent + k.to_s + ":"
              if part.composite?
                env.say(mine, colors[part.status])
                part.yaml_say(env, options, colors, indent+1)
              else
                part_str = part.to_yaml
                part_str =~ /---\s*(.*)$/
                part_str = $1
                env.say(mine + " " + part_str, colors[part.status])
              end
            end
          }
        end
      
        ############################################################################
        ### Equality and hash code
        ############################################################################
      
        # @see DbAgile::Core::SchemaObject
        def look_same_as?(other)
          return nil unless other.kind_of?(self.class)
          my_parts = part_keys(true)
          return false unless (my_parts == other.part_keys(true))
          my_parts.all?{|k| self[k].look_same_as?(other[k])}
        end
      
        # @see DbAgile::Core::SchemaObject
        def dup
          self.class.new(_dup_parts)
        end
      
        # Returns a string representation
        def to_s
          "#{DbAgile::RubyTools::unqualified_class_name(self.class)}"
        end
        
      end # class Composite
    end # module Schema
  end # module Core
end # module DbAgile