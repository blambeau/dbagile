module DbAgile
  class Command
    module Db
      #
      # Stage the current database
      #
      # Usage: dba #{command_name}
      #
      class Stage < Command
        Command::build_me(self, __FILE__)
      
        #
        # Executes the command.
        #
        # @return [DbAgile::Core::Database] the database
        #
        def execute_command
          with_current_database do |db|
            # left, right and merge
            left   = db.effective_schema(true)
            right  = db.announced_schema(true)
            merged = left + right
          
            # Bypass situations
            if merged.status == DbAgile::Core::Schema::NO_CHANGE
              say("Nothing to stage", :magenta)
              return
            elsif environment.interactive?
              # Show what will be performed
              DbAgile::dba(environment){|dba| dba.schema_diff %w{-u effective announced}}
              say("---")
              DbAgile::dba(environment){|dba| dba.schema_sql_script %w{stage effective announced}}
              say("\n")
              
              # Ask confirmation now
              answer = environment.ask("Are you sure?"){|q| q.validate = /^y(es)?|n(o)?|q(uit)?/i}
              return unless answer =~ /^y/i
            end
          
            # Everything seems ok now!
            begin
              stage(db, merged)
            rescue => ex
              say("Sorry, staging process failed for some reason.", :red)
              raise
            end
          end
        end
        
        # Makes staging itself
        def stage(db, merged)
          script = DbAgile::Core::Schema::stage_script(merged)
          with_connection(db) do |conn|
            
            # stage the real database
            sql_script = conn.script2sql(script)
            conn.transaction do |t|
              t.direct_sql(sql_script)
              
              # split schemas now
              schemas = merged.split{|obj|
                case obj.status
                  when DbAgile::Core::Schema::DROPPED
                    :dropped
                  else
                    :effective
                end
              }
              
              # save schemas
              if s = schemas[:effective]
                db.set_effective_schema(s)
              end
            end
          end
        end
        
      end # class Stage
    end # module Db
  end # class Command
end # module DbAgile