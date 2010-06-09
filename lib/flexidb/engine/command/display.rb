class FlexiDB::Engine::Command::Display < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "display TABLE_NAME|SELECT..."
  end  
      
  # Returns command's help
  def help
    "display contents of a table"
  end
      
  # Executes the command on the engine
  def execute(engine, env, source)
    dataset = case source
      when Symbol, /^[^\s]+$/
        engine.database.dataset(source.to_sym)
      when String
        engine.database.dataset(source)
      else
        source
    end
    env.say(dataset.to_a.inspect)
  end
        
end # class Quit