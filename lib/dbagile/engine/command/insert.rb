class DbAgile::Engine::Command::Insert < DbAgile::Engine::Command
        
  # Command's names
  names 'insert'      
  
  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:TUPLE,      Hash)
  }
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:TUPLES,     Array){|a| a.all?{|t| t.kind_of?(Hash)}}
  }
        
  # Command's synopsys
  synopsis "insert a {:attribute_name => value, ...} tuple inside a table"
      
  # Executes the command on the engine
  def execute_1(engine, table_name, tuple)
    engine.connected!
    engine.database.insert(table_name, tuple)
  end
        
  # Executes the command on the engine
  def execute_2(engine, table_name, tuples)
    engine.connected!
    tuples.collect do |t|
      engine.database.insert(table_name, t)
    end
  end
        
end # class Quit