class FlexiDB::Engine::Command::Quit < FlexiDB::Engine::Command
        
  # Executes the command on the engine
  def execute(engine, env)
    engine.__disconnect
    engine.__quit
  end
        
end # class Quit