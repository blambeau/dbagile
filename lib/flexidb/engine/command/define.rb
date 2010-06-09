class FlexiDB::Engine::Command::Define < FlexiDB::Engine::Command
        
  # Returns command's banner
  def banner
    "define TABLE_NAME, {HEADING...}"
  end
        
  # Returns command's help
  def help
    "define/create a new table with a specific {:attribute_name => AttributeType, ...} heading"
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