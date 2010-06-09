class FlexiDB::Engine::Command::Disconnect < FlexiDB::Engine::Command
        
  # Executes the command on the engine
  def execute(engine, env)
    engine.__disconnect
  end
        
end # class Quit