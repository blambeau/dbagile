class FlexiDB::Engine::Command::Sql < FlexiDB::Engine::Command

  # Returns command's banner
  def banner
    "sql COMMAND"
  end

  # Returns command's help
  def help
    "send a sql command to the database server"
  end
      
  # Executes the command on the engine
  def execute(engine, env, cmd)
    if /^\s*(select|SELECT)/ =~ cmd
      engine.display(engine, env, engine.database.dataset(cmd))
    else
      result = engine.database.direct_sql(cmd)
      env.say(result.inspect)
    end
  end
        
end # class Quit