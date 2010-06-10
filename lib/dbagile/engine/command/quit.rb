class DbAgile::Engine::Command::Quit < DbAgile::Engine::Command
        
  # Command's names
  names '\q', 'quit'

  # Command's signatures
  signature{}

  # Command's synopsys
  synopsis "quit dbagile"
      
  # Executes the command on the engine
  def execute_1(engine)
    engine.disconnect
    engine.quit
    "bye"
  end
        
end # class Quit