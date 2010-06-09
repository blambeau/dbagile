class FlexiDB::Engine::Command::Quit < FlexiDB::Engine::Command
        
  # Command's names
  names '\q', 'quit'

  # Command's signatures
  signature{}

  # Command's synopsys
  synopsis "quit flexidb"
      
  # Executes the command on the engine
  def execute(engine, env)
    engine.__disconnect
    engine.__quit
  end
        
end # class Quit