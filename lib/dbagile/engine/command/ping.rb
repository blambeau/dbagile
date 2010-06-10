class DbAgile::Engine::Command::Ping < DbAgile::Engine::Command
        
  # Command's names
  names 'ping'

  # Command's signatures
  signature{}

  # Command's synopsys
  synopsis "ping the current database to see if it responds"
      
  # Executes the command on the engine
  def execute_1(engine)
    if engine.connected?
      engine.database.adapter.ping
    else
      false
    end
  end
        
end # class Quit