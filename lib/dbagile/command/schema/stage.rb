module DbAgile
  class Command
    module Schema
      #
      # Apply schema:diff on the effective/physical database.
      #
      # Usage: dba #{command_name}
      #
      # For more information about schema comparisons, try 'dba help schema:diff'
      #
      class Stage < Command
        include Schema::ComparisonBased
        Command::build_me(self, __FILE__)
      
        attr_accessor :dry_run
      
        # Contribute to options
        def add_options(opt)
          opt.separator nil
          opt.separator "Options:"
          opt.on('--dry-run', "Trace SQL statements on STDOUT only, do nothing on the database") do |value|
            self.dry_run = true
          end
        end
      
        # Normalizes the pending arguments
        def normalize_pending_arguments(arguments)
          normalize_comparison_arguments(arguments)
        end
        
        # Executes the command
        def execute_command
          with_current_config do |config|
            # left schema
            left = config.effective_schema(true)
            left.check!
          
            # right schema
            right = config.announced_schema(true)
            right.check!
          
            # Merge schemas now
            merged = DbAgile::Core::Schema::merge(left, right)
            if merged.annotation == :same
              say("Nothing to do", :magenta)
              nil
            else
              # Show the diff and ask confirmation
              show_diff(left, right, merged, environment, :skip_unchanged => true)
              if self.dry_run or environment.ask("Are you sure? ") =~ /^\s*[y|Y]/
                sql = with_connection(config){|conn|
                  conn.transaction do |t|
                    sql = t.stage_schema(merged, {:dry_run => self.dry_run})
                    config.set_effective_schema(right) unless self.dry_run
                    sql
                  end
                }
                say(sql) if self.dry_run
                sql
              else
                say("Cancelled by user.", :magenta)
                nil
              end
            end
          end
        end
        
      end # class SchemaDump
    end # module Schema
  end # class Command
end # module DbAgile
