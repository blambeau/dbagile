class FlexiDB::Engine::Command::Ping < FlexiDB::Engine::Command
        
  # Returns command's help
  def help
    "ping the current database to see if it responds"
  end
      
  # Executes the command on the engine
  def execute(engine, env)
    env.say(engine.database.adapter.ping)
  end
        
end # class Quit