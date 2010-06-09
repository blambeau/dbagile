class FlexiDB::Engine::Command::Connect < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "connect database_uri"
  end  
      
  # Executes the command on the engine
  def execute(engine, env, uri)
    engine.__connect(uri)
  end
        
end # class Quit