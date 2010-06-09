class FlexiDB::Engine::Command::Ping < FlexiDB::Engine::Command
        
  # Command's names
  names 'ping'

  # Command's signatures
  signature{}

  # Command's synopsys
  synopsis "ping the current database to see if it responds"
      
  # Executes the command on the engine
  def execute(engine, env)
    env.say(engine.database.adapter.ping)
  end
        
end # class Quit