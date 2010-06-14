class DbAgile::Engine::Command::Exists < DbAgile::Engine::Command
        
  # Command's names
  names 'exists?'

  # Command's signatures
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:TUPLE, Hash)
  }

  # Command's synopsys
  synopsis "checks if a tuple exists inside a table"
            
  # Executes the command on the engine
  def execute_1(engine, table_name, tuple)
    engine.connected!
    engine.database.exists?(table_name, tuple)
  end
        
end # class Quit