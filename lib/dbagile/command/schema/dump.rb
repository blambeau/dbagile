module DbAgile
  class Command
    module Schema
      #
      # Dump a schema of the current database
      #
      # Usage: dba #{command_name} [options] [announced|effective|physical]
      #
      # This command dumps the schema of the current database on the output console. 
      # Without argument, the announced schema is implicit. This command uses the 
      # fallback chain (announced -> effective -> physical) and has no side-effect 
      # on the database itself (read-only).
      #
      # Schema filtering is possible via the --include and --exclude options, which
      # allow including/excluding specific schema object kinds. When used conjointly, 
      # the semantics is '--include AND NOT(--exclude)'. The different object kinds
      # are:
      #   * logical            (all logical objects, see indented list below)
      #     * table            (base tables)
      #     * view             (derived tables, aka views)
      #     * constraint       (all constraints, see indented list below)
      #       * candidate_key  (all candidate keys, primary or not)
      #       * primary_key    (all primary keys)
      #       * foreign_key    (all foreign keys)
      #   * physical           (all physical objects, see indented list below)
      #     * index            (all physical indexes)
      #
      # A typical usage of schema filtering is to generate a script that drops all 
      # constraints at once by chaining this command with sql-script:
      #
      #   dba schema:dump --include=constraint | dba schema:sql-script --stdin drop
      #
      # NOTE: Schema-checking is on by default, which may lead to checking errors, 
      #       typically when reverse engineering poorly designed databases. Doing so 
      #       immediately informs you about a potential problem.
      #
      #       Use --no-check to bypass schema checking. See also schema:check.
      #
      class Dump < Command
        include Schema::Commons
        Command::build_me(self, __FILE__)
        
        QUERIES = {
          :logical       => [:logical?],
          :table         => [:attribute?, :constraint?],
          :view          => [:relview?],
          :constraint    => [:constraint?],
          :candidate_key => [:candidate_key], 
          :primary_key   => [:primary_key],
          :foreign_key   => [:foreign_key],
          :physical      => [:physical?],
          :index         => [:index?]
        }
        
        # Returns :single
        def kind_of_schema_arguments
          :single
        end
        
        # Include and exclude options
        attr_accessor :include_kind, :exclude_kind
        
        # Marks a kind a begin included
        def include_kind!(kind)
          if queries = QUERIES[kind]
            self.include_kind ||= []
            self.include_kind += queries
          else
            raise DbAgile::Error, "Unrecognized object kind #{kind}"
          end
        end
        
        # Marks a kind a begin excluded
        def exclude_kind!(kind)
          if queries = QUERIES[kind]
            self.exclude_kind ||= []
            self.exclude_kind += queries
          else
            raise DbAgile::Error, "Unrecognized object kind #{kind}"
          end
        end
        
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          add_check_options(opt)
          add_stdin_options(opt)
          opt.on('--include=x,y,z', Array, 
                 "Include object kinds (logical, physical, candidate_key, ...)") do |values|
            values.each{|value| include_kind!(value.to_sym)}
          end
          opt.on('--exclude=x,y,z', Array, 
                 "Exclude object kinds (logical, physical, candidate_key, ...)") do |values|
            values.each{|value| exclude_kind!(value.to_sym)}
          end
        end
        
        # Returns the kind of an object
        def include?(obj)
          if include_kind && !include_kind.any?{|kind| obj.send(kind)}
            return false
          end
          if exclude_kind && exclude_kind.any?{|kind| obj.send(kind)}
            return false
          end
          true
        end
        
        # Filters the schema according to --select and --reject 
        # options.
        def filter_shema(schema)
          schema.filter{|obj| include?(obj)}
        end
      
        # Executes the command
        def execute_command
          with_schema do |schema|
            say("# Schema of #{schema.schema_identifier.inspect}", :magenta)
            schema = filter_shema(schema)
            flush(schema.to_yaml)
            schema
          end
        end
      
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
