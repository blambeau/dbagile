class FlexiDB::Engine::Command::Sql < FlexiDB::Engine::Command

  # Command's names
  names '\s', 'sql'

  # Command's signatures
  signature{
    argument(:QUERY, String)
  }

  # Command's synopsys
  synopsis "send a sql command to the database server"
      
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