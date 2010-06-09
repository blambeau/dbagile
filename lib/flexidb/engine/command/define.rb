class FlexiDB::Engine::Command::Define < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "define table_name, {heading...}"
  end
        
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^,]+),(.*)$/
      name, heading = $1.to_sym, Kernel.eval($2)
      engine.database.create_table(name, heading)
      env.say(true)
    else
      env.say(banner)
    end
  end
        
end # class Quit