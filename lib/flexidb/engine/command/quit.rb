class FlexiDB::Engine::Command::Quit < FlexiDB::Engine::Command
        
  def banner
    '\q[uit], quit'
  end
        
  # Returns command's help
  def help
    "quit flexidb"
  end
      
  # Executes the command on the engine
  def execute(engine, env)
    engine.__disconnect
    engine.__quit
  end
        
end # class Quit