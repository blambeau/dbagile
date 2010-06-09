class FlexiDB::Engine::Command::Ping < FlexiDB::Engine::Command
        
  # Executes the command on the engine
  def execute(engine, env)
    env.say(engine.database.adapter.ping)
  end
        
end # class Quit