class FlexiDB::Engine::Command::Display < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "display TABLE_NAME"
  end  
      
  # Returns command's help
  def help
    "display contents of a table"
  end
      
  # Executes the command on the engine
  def execute(engine, env, table_name)
    if engine.database.has_table?(table_name.to_sym)
      env.say(engine.database.dataset(table_name.to_sym).to_a.inspect)
    else
      env.error("No such table #{table_name}")
    end
  end
        
end # class Quit