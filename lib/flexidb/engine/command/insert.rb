class FlexiDB::Engine::Command::Insert < FlexiDB::Engine::Command
        
  # Command's names
  names 'insert'      
  
  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:TUPLE,      Hash)
  }
        
  # Command's synopsys
  synopsis "insert a {:attribute_name => value, ...} tuple inside a table"
      
  # Executes the command on the engine
  def execute_1(engine, table_name, tuple)
    engine.database.insert(table_name, tuple)
  end
        
end # class Quit