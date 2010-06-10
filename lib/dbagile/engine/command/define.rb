class DbAgile::Engine::Command::Define < DbAgile::Engine::Command
        
  # Command's names
  names 'define'
        
  # Command's signature
  signature{
    argument(:TABLE_NAME, Symbol)
    argument(:HEADING,    Hash){|h| h.keys.all?{|k| Symbol===k} and h.values.all?{|v| Class===v}}
  }
  
  # Command's synopsis
  synopsis "define/create a new table with a specific {:attribute_name => AttributeType, ...} heading"
      
  # Executes on main signature
  def execute_1(engine, table_name, heading)
    engine.connected!
    engine.database.create_table(table_name, heading)
  end
      
end # class Quit