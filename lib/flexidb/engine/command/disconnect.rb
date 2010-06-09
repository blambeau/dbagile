class FlexiDB::Engine::Command::Disconnect < FlexiDB::Engine::Command
        
  # Returns command's help
  def help
    "disconnect from the current database"
  end
      
  # Executes the command on the engine
  def execute(engine, env)
    engine.__disconnect
  end
        
end # class Quit