class FlexiDB::Engine::Command::Insert < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "insert TABLE_NAME, {TUPLE...}"
  end
        
  # Returns command's help
  def help
    "insert a {:attribute_name => value, ...} tuple inside a table"
  end
      
  # Executes the command on the engine
  def execute(engine, env, args)
    if args =~ /^([^,]+),(.*)$/
      name, tuple = $1.strip.to_sym, Kernel.eval($2)
      env.say(engine.database.insert(name, tuple).inspect)
    else
      env.say(banner)
    end
  end
        
end # class Quit