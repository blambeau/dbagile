module DbAgile
  class Command
    module Schema
      #
      # Print a SQL script for staging from an effective to an announced schema
      #
      # Usage: dba #{command_name}
      #
      class StageScript < Command
        include ComparisonBased
        Command::build_me(self, __FILE__)
        
        # Executes the command
        def execute_command
          with_current_database{|database|
            # left schema
            left = database.effective_schema(true)
            left.check!
        
            # right schema
            right = database.announced_schema(true)
            right.check!
        
            # Merge schemas now
            merged = DbAgile::Core::Schema::merge(left, right)
            if merged.status == DbAgile::Core::Schema::NO_CHANGE
              say("Nothing to stage", :magenta)
            else
              with_connection(database){|conn|
                script = DbAgile::Core::Schema::stage_script(merged)
                conn.script2sql(script, environment.output_buffer)
              }
            end
          }
        end
      
      end # class CreateScript
    end # module Schema
  end # class Command
end # module DbAgile