class FlexiDB::Engine::Command::Insert < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "insert table_name, {tuple...}"
  end
        
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^,]+),(.*)$/
      name, tuple = $1.strip.to_sym, Kernel.eval($2)
      env.say(engine.database.insert(name, tuple))
    else
      env.say(banner)
    end
  end
        
end # class Quit