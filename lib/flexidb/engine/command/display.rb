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
        
  # Command's synopsis
  synopsis "display contents of a table"
      
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