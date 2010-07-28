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
      
        # Stage options
        attr_accessor :stage_options
      
        # Contribute to options
        def add_options(opt)
          @stage_options = {:expand => true, :collapse => true}
          opt.separator nil
          opt.separator "Options:"
          opt.on('--dry-run', "Trace SQL statements on STDOUT only, do nothing on the database") do
            self.stage_options[:dry_run] = true
          end
          opt.on('--[no-]expand',
                 'Perform/Avoid schema expansions (creation of missing database objects)') do |value|
            self.stage_options[:expand] = value
          end
          opt.on('--[no-]collapse',
                 'Perform/Avoid schema collapsing (removal of deprecated database object)') do
            self.stage_options[:collapse] = value
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
                sql_script = nil
                with_connection(config){|conn|
                  conn.transaction do |t|
                    sql_script = t.stage_schema(merged, self.stage_options)
                    # unless self.dry_run
                    #   config.set_effective_schema(right) 
                    # end
                  end
                }
                if self.dry_run
                  say(sql)
                end
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
