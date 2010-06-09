class FlexiDB::Engine::Command::Display < FlexiDB::Engine::Command
        
  # Executes the command on the engine
  def execute(engine, env, table_name)
    if engine.database.has_table?(table_name.to_sym)
      env.say(engine.database.dataset(table_name.to_sym).to_a.inspect)
    else
      env.error("No such table #{table_name}")
    end
  end
        
end # class Quit