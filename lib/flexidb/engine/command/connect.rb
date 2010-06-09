class FlexiDB::Engine::Command::Connect < FlexiDB::Engine::Command
        
  # Executes the command on the engine
  def execute(engine, env, uri)
    engine.__connect(uri)
  end
        
end # class Quit