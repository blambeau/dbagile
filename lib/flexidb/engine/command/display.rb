class FlexiDB::Engine::Command::Display < FlexiDB::Engine::Command
  
  # Command's names
  names '\d', 'display'
  
  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
  }
  signature{
    argument(:QUERY, String)
  }
  signature{
    argument(:OBJECT, Object)
  }
        
  # Command's synopsis
  synopsis "display contents of a table/sql query/ruby object"
  
  # Executes with a table name as argument
  def execute_1(engine, table_name)
    do_display(engine, engine.database.dataset(table_name))
  end
      
  # Executes with a query as argument
  def execute_2(engine, query)
    do_display(engine, engine.database.dataset(query))
  end
      
  # Executes with an object as argument
  def execute_3(engine, object)
    do_display(engine, object)
  end
      
        
end # class Quit