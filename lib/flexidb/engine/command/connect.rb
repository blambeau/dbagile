class FlexiDB::Engine::Command::Connect < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "connect URI"
  end  

  # Returns command's help
  def help
    "connect to a database through a adapter://user@host/database URI"
  end
      
  # Executes the command on the engine
  def execute(engine, env, uri)
    engine.__connect(uri)
  end
        
end # class Quit