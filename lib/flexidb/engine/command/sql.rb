class FlexiDB::Engine::Command::Sql < FlexiDB::Engine::Command

  # Command's names
  names '\s', 'sql'

  # Command's signatures
  signature{
    argument(:QUERY, /^\s*(select|SELECT)/)
  }
  signature{
    argument(:QUERY, String)
  }

  # Command's synopsys
  synopsis "send a sql command to the database server"
      
  # Executes a select query
  def execute_1(engine, query)
    engine.database.dataset(query)
  end
        
  # Executes the command on the engine
  def execute_2(engine, cmd)
    engine.database.direct_sql(cmd)
  end
        
end # class Quit