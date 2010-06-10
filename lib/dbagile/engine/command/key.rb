class DbAgile::Engine::Command::Key < DbAgile::Engine::Command
        
  # Command's names
  names 'key'

  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:COLUMNS, Array){|arr| arr.all?{|c| Symbol === c} }
  }

  # Command's synopsys
  synopsis "Adds a candidate key to a given table"
            
  # Executes the command on the engine
  def execute_1(engine, table_name, columns)
    engine.connected!
    engine.columns_exist!(table_name, columns)
    engine.database.key(table_name, columns)
  end
        
end # class Quit